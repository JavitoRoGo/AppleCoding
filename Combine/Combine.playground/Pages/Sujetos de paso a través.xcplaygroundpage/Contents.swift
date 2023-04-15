//: [Previous](@previous)

import Combine
import UIKit

// SUJETOS DE PASO A TRAVÉS O PASSTHROUGH SUBJECTS

// Son los sujetos que sí pertenecen al paradigma de la programación declarativa. Nos permiten crear sujetos que no tienen valor de inicio ni guardan su último valor publicado.
// No tienen la propiedad value ni tampoco hay que inicializarlos, sino simplemente decir que los queremos y luego decidimos cuándo queremos empezar a emitir.
// Veamos un ejemplo de creación de un sujeto de paso, y además lo crearemos de forma que devuelva un tipo de error que también vamos a crear

enum ErroresVarios: Error, LocalizedError {
    case haCascado(Int), haPetado, haReventado
    
    var errorDescription: String? {
        switch self {
        case .haCascado(let value):
            return "Ha cascado porque sí con el valor \(value)"
        case .haPetado:
            return "Ha petado porque le tocaba"
        case .haReventado:
            return "Ha reventado porque no le cabía más"
        }
    }
}

let subject = PassthroughSubject<Int, ErroresVarios>()

// creamos el envío de valores
subject.send(1)
// creamos el suscriptor
let subscriber = subject.sink { completion in
    switch completion {
    case .finished: print("Todo ha terminado bien")
    case .failure(let error): print("Ha ocurrido un error: \(error.localizedDescription)")
    }
} receiveValue: { value in
    print("Ha recibido el valor \(value).")
} // con este tipo de sujeto, el suscriptor solo recibe los valores emitidos después de su creación (al contrario que el sujeto de valor actual). El suscriptor no empieza a escuchar las emisiones hasta que no se acopla al publicador, no escucha las emisiones anteriores
subject.send(2)
subject.send(3)

//subject.send(completion: .finished) //aquí termina el suscriptor y no recibe lo siguiente
subject.send(completion: .failure(.haCascado(3)))
//la línea anterior devuelve: Ha ocurrido un error: Ha cascado porque sí con el valor 3
subject.send(4)


//: [Next](@next)
