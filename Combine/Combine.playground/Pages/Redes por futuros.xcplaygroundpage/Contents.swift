//: [Previous](@previous)

import Combine
import UIKit

// REDES POR FUTUROS

// Veamos la integración de Combine con Cocoa y la librería fundación de swift para entender mejor los futuros, y cómo se usan las llamadas a red descargando una imagen:

let url = URL(string: "https://i.blogs.es/f7b0ed/steve-jobs/2560_3000.jpg")!

enum ErroresRed: Error {
    case general
    case notFound(Int) //esto es para recoger el código del error y poder propagarlo
    case imagenNoValida
}

func getImage(url: URL) -> Future<Data,ErroresRed> {
    .init { promise in
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                //si entra aquí por el else, devolvemos la promesa con el fallo, y de tipo general
                promise(.failure(.general))
                return
            }
            if response.statusCode == 200 { //este el código de que todo ha ido bien
                promise(.success(data))
            } else {
                promise(.failure(.notFound(response.statusCode))) //para recoger el código del error
            }
        }.resume()
    }
}

var subscribers = Set<AnyCancellable>()

getImage(url: url) //este es el publicador porque devuelve un futuro
    .compactMap { UIImage(data: $0) }
    .sink { completion in //así creamos el suscriptor
        switch completion {
        case .finished:
            print("Finalizado con éxito")
        case .failure(let error):
            if case .notFound(let code) = error {
                print("No encontrada con estado \(code)")
            } else {
                print("Ha habido un error \(error)")
            }
        }
    } receiveValue: { image in
        print(image)
        image
    }
    .store(in: &subscribers) //porque los suscriptores tienen que guardarse siempre en algún sitio



//: [Next](@next)
