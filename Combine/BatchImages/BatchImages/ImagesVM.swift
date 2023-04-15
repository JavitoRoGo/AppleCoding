//
//  ImagesVM.swift
//  BatchImages
//
//  Created by Javier Rodríguez Gómez on 13/11/22.
//

import Combine
import SwiftUI

// Lo primero siempre debe ser definir el view-model, puesto que los datos es lo más importante
// Lo que vamos a hacer es mostrar las imágenes del array de URL del modelo en un grid

final class BatchImagesVM: ObservableObject {
    var subscribers = Set<AnyCancellable>()
    
    @Published var fotos: [Fotos] = []
    
    // Función para crear un publisher para cada foto y transformar los datos en Image
    func getImagePublisher(url: URL) -> AnyPublisher<Fotos,URLError> {
        URLSession.shared
            .dataTaskPublisher(for: url) // llamada a la url para buscar los datos
            .map(\.data) // recuperar los datos en bruto (sin gestionar errores)
            .compactMap { UIImage(data: $0) } // pasar data a UIImage
            .map { Fotos(image: Image(uiImage: $0)) } // pasar UIImage a Fotos
            .eraseToAnyPublisher()
    }
    
    // Array de publicadores que coge el array del modelo y transforma las urls en imágenes. Este array es para la función siguiente, que los mezcla todos y nos devuelve [Fotos]
    var imagePublishers: [AnyPublisher<Fotos, URLError>] {
        ImagesData().images.map { getImagePublisher(url: $0) }
    }
    
    func getImages() {
        Publishers.MergeMany(imagePublishers)
            .collect() //para que devuelva array y no una a una
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error en la descarga: \(error)")
                }
            } receiveValue: { fotosRecuperadas in
                self.fotos = fotosRecuperadas
            }
            .store(in: &subscribers)
    }
}
