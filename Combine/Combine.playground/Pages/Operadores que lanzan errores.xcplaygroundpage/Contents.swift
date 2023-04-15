//: [Previous](@previous)

import Combine
import UIKit

// OPERADORES QUE LANZAN ERRORES

// Existen las versiones de tipo try de cada uno de los operadores vistos, con las que podremos lanzar errores con el uso de throw o evaluar operaciones try sin el flujo do-try-catch

let imagenesPublisher = ["Alias", "Alien", "BasicInstinct", "Paquito", "Aliens", "AmazingStories", "BoysFromBrazil", "AmericanTail"].publisher

imagenesPublisher
    .tryCompactMap { file in
        if let ruta = Bundle.main.url(forResource: file, withExtension: "jpg") {
            return try Data(contentsOf: ruta)
        } else {
            return nil
        }
    }
    .compactMap { dataImage in
        UIImage(data: dataImage)
    }
    .sink { completion in
        if case .failure(let error) = completion {
            print("Ha habido un error: \(error)")
        }
    } receiveValue: { image in
        print("Normal: \(image)")
        image
    }

// Vamos a hacer lo mismo de antes pero gestionando el error y el acabado, y usando un operardo de secuencia

imagenesPublisher
    .tryCompactMap { file in
        if let ruta = Bundle.main.url(forResource: file, withExtension: "jpg") {
            return try Data(contentsOf: ruta)
        } else {
            return nil
        }
    }
    .compactMap { dataImage in
        UIImage(data: dataImage)
    }
    .collect() //unifica todas las emisiones en una
    .sink { completion in
        switch completion {
        case .finished:
            print("Ha finalizado la descarga")
        case .failure(let error):
            print("Error en la descarga de imagen: \(error)")
        }
    } receiveValue: { images in
        //con collect tenemos ahora un array porque se lanzan a la vez
        images.forEach { image in
            print("Collect: \(image)")
            image
        }
    }




//: [Next](@next)
