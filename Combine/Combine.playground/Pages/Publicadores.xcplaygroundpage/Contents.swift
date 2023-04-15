//: [Previous](@previous)

import Combine

// PUBLICADORES

// Los publicadores son el punto de inicio de la cadena de trabajo con Combine
// Un publicador es un array de futuros. Por tanto, existe la posibilidad de que cada elemento de una colección pueda ser emitido

let publisher = [1,2,3,4,3,9,5,7,4,7,8,5,3,5].publisher //está implementado como método, y es un publicador que nunca falla, su tipo es Publishers.Sequence<[Int], Never>

let subscriber = publisher.sink { print("Recibido \($0)") }

 // Veamos otro ejemplo, en este caso, usando también un publicador que nunca falla y asignando un valor con keyPath
class UnObjeto {
    var valor = "" {
        //ponemos un observador de propiedad para comprobar que se asigna el valor del publicador
        didSet {
            print("Asignado el valor \(valor)")
        }
    }
}

let objeto1 = UnObjeto()

let publisher2 = ["Hola", "Adiós", "Hasta luego", "¿Qué tal?"].publisher
let subs2 = publisher2.assign(to: \.valor, on: objeto1) // assingn solo funciona con publisher que no fallan
// Estamos asignando cada valor del publicador a la ruta de la propiedad de la clase


//: [Next](@next)
