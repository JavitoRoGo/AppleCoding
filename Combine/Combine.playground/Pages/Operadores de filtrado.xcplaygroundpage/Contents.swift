//: [Previous](@previous)

import Combine
import UIKit

// OPERADORES DE FILTRADO

// Nos permiten filtrar lo que llega desde el publicador para hacer una selección y descartar lo que no nos interese

let number = [1,2,4,3,5,4,6,7,5,8,6,9,7,9,7,7,6,8,6,7,5,6,4,5,3,4,3,6,4,7,5,8].publisher

// Ejemplo de filtrado
number
    .filter { $0.isMultiple(of: 3) }
    .sink { print("Múltiplos de 3: \($0)") }

// Ejemplo de borrar duplicados
number
    .removeDuplicates() //borra el duplicado cuando la salida es igual a la anterior, cuando los iguales son sucesivos
    .sink { print("Borrar duplicados: \($0)") }

number
    .ignoreOutput() //ignora los resultados, por lo que el suscriptor solo recibirá la señal de terminado y devuleve "Ha finalizado" y nada más
    .sink { completion in
        if case .finished = completion {
            print("Ha finalizado")
        }
    } receiveValue: { value in
        print("Ha llegado un \(value)")
    }

number
    .first { $0 % 3 == 0 } //primer valor que se múltiplo de 3
    .sink { print("Primer valor: \($0)") }

number
    .last { $0 % 3 == 0 } //último valor que se múltiplo de 3
// para que funcione .last tiene que haber una señal de finished del publicador
    .sink { print("Último valor: \($0)") }

// Veamos otro tipo de filtrado que ignora todas las señales emitidas hasta que se valide una condición
let semaforo = PassthroughSubject<Void, Never>()
let numbers = PassthroughSubject<Int, Never>()
numbers
    .drop(untilOutputFrom: semaforo) //numbers no emitirá hasta que lo haga semaforo
    .sink { print("DROP: \($0)") }

let nums = [1,2,4,3,5,4,6,7,5,8,6,9,7,9,7,7,6,8,6,7,5,6,4,5,3,4,3,6,4,7,5,8]
nums.forEach { n in
    numbers.send(n)
    if n == 3 {
        semaforo.send()
        // numbers emitirá desde este momento, cuando se active semaforo
    }
}



//: [Next](@next)
