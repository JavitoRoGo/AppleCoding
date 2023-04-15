//: [Previous](@previous)

import Combine
import UIKit

// IMPLEMENTACIÓN DE FUTUROS Y SUS PROMESAS
// Recordar que un futuro es un tipo Result que nos dice lo que podemos recibir. Veamos un ejemplo con una función síncrona normal y una función asíncrona

func incremento(valor:Int) -> Int {
    valor + 1
}
incremento(valor: 4)

func incrementoTiempo(valor:Int) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: { print(valor + 1) })
    // esta función no nos permite devolver ningún valor, y para resolver esto usamos los futuros como en la siguiente función
}
incrementoTiempo(valor: 4)

func incrementoFuturo(valor: Int, tiempo: TimeInterval) -> Future<Int, Never> {
    //el Never es un tipo de valor vacío que no contiene nada, es como un placeholder, y se puede usar para indicar, como en este caso, que esta función nunca va a propagar errores
    Future<Int,Never> { promise in //esta promesa sería el $0
        DispatchQueue.global().asyncAfter(deadline: .now() + tiempo) {
            promise(.success(valor + 1)) //así se invoca la promesa y se devuelve el resultado
        }
    }
    //esta función devuelve un valor futuro (sin error en el ejemplo) invocando a la promesa
}

let future = incrementoFuturo(valor: 4, tiempo: 4) // esto nos da un Combine.Future, nos falta invocar al suscriptor:
let suscriptor = future.sink { print($0) }
// Lo anterior es cuando no hay error posible en el futuro, como en el ejemplo que usamos Never para el error
// Pero si puede haber error, entonces hay que inyectar dos closures: uno para el caso que el proceso termine, y otro con la ejecución en caso de success (como el anterior):
let future2 = incrementoFuturo(valor: 6, tiempo: 6)
let suscriptor2 = future2.sink(receiveCompletion: { completion in
    if case .finished = completion {
        print("Ha terminado")
    }
}, receiveValue: { num in
    print(num)
})


//: [Next](@next)
