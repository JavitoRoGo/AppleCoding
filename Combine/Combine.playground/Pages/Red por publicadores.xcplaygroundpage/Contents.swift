//: [Previous](@previous)

import Combine
import UIKit

// RED POR PUBLICADORES

// Veamos la implementación que tiene la API de urlSession para trabajar directamente con publicadores, la mejor forma de descargar cualquier cosa en una app
// Como ejemplo, vamos a descargar la misma imagen del ejemplo anterior pero de otra forma, usando urlSession

var subscribers = Set<AnyCancellable>()

let url = URL(string: "https://i.blogs.es/f7b0ed/steve-jobs/2560_3000.jpg")!

URLSession.shared
    .dataTaskPublisher(for: url) //este es el publicador
// esto devuelve las 3 cosas: data, response y error
    .tryMap { (data, response) in
        if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            return data
        } else {
            throw URLError(.badURL)
        }
    }
    .compactMap { UIImage(data: $0) }
    .replaceError(with: UIImage(named: "Alias.jpg", in: .main, with: .none)!) //esto sustituye el error, es decir, en caso de error en los pasos anteriores usa esta imagen. Es como asignar una imagen por defecto en caso de error
    .sink { completion in
        switch completion {
        case .finished:
            print("Finished")
        case .failure(let error):
            print("Error \(error)")
        }
    } receiveValue: { image in
        print(image)
        image
    }
    .store(in: &subscribers)


// Todo lo anterior se puede poner dentro de una clase para ser reutilizado, y si usamos el reemplazo de error podemos simplificar el .sink porque no haría falta ya gestionar el error, y cambiándolo por .assign. Además, la llamada de urlSession iría dentro de una función
// Quedaría de la siguiente forma:

final class SteveJobs {
    var image: UIImage?
    var subscribers = Set<AnyCancellable>()
    let url = URL(string: "https://i.blogs.es/f7b0ed/steve-jobs/2560_3000.jpg")!

    func getJobs() {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    return data
                } else {
                    throw URLError(.badURL)
                }
            }
            .compactMap { UIImage(data: $0) }
            .replaceError(with: UIImage(named: "Alias.jpg", in: .main, with: .none))
            .assign(to: \.image, on: self) //asignación directa a la propiedad
            .store(in: &subscribers)
    }
}

let jobs1 = SteveJobs()
jobs1.getJobs()
sleep(1)
jobs1.image

// El resumen de esto es para recuperar una imagen de red, y si falla, usar una imagen por defecto precargada en la app


//: [Next](@next)
