//: [Previous](@previous)

import Combine
import UIKit

// OPERADORES DE DEPURACIÓN

// Estamos ante una API declarativa y por lo tanto, su capacidad para ser ejecutada en modo de depuración es más limitada por las vías tradicionales. Por eso existen operadores pensados específicamente para depurar el código y saber qué se está emitiendo en cada punto de nuestro stream
// Veamos un ejemplo con el código de la página anterior al que añadimos puntos de ruptura

let imagenesPublisher = ["Alias", "Alien", "BasicInstinct", "Paquito", "Aliens", "AmazingStories", "BoysFromBrazil", "AmericanTail"].publisher

// Podemos ver lo que se está propagando a través de una clase conformada a un protocolo específico:
class ImageLogger: TextOutputStream {
    func write(_ string: String) {
        // Se recibe el dato que va por el stream pero pasado a cadena
        print("Recibidos datos: \(string)")
        // lo usamos poniendo un print dentro de la secuencia siguiente
    }
}

imagenesPublisher
    .tryCompactMap { file in
        if let ruta = Bundle.main.url(forResource: file, withExtension: "jpg") {
            return try Data(contentsOf: ruta)
        } else {
            return nil
        }
    }
// Otra herramienta es un gestor de eventos:
    .handleEvents(receiveOutput: { print("Total de datos \($0.count)") })
    .breakpoint(receiveOutput: { $0.count == 0 }) // para el proceso cuando el Data que viene por stream está vacío
    .compactMap { dataImage in
        UIImage(data: dataImage)
    }
    .breakpointOnError() // si el proceso lanza un error la ejecución se parará aquí
    .print("Control post CompactMap", to: ImageLogger())
    .collect()
    .sink { completion in
        switch completion {
        case .finished:
            print("Ha finalizado la descarga")
        case .failure(let error):
            print("Error en la descarga de imagen: \(error)")
        }
    } receiveValue: { images in
        images.forEach { image in
            print("Collect: \(image)")
            image
        }
    }



//: [Next](@next)
