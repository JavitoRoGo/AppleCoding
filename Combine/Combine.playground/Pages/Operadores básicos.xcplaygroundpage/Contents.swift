//: [Previous](@previous)

import Combine

// Veamos cómo trabajar con los operadores, que pueden añadirse directamente después del publicador

let publisher = [1,2,3,4,5,6,7,8,9].publisher
    .filter { $0 < 7 }
    .map { "\($0)" }
    .collect() // con esto lo que hacemos es que reúna toddas las señales en una sola, que no emita una a una sino que las junte todas a la vez hasta que el publicador termine, y las emite todas juntas de una sola vez
//y si entre los paréntesis ponemos un número entero, emitirá las señales cada 2, 3 o lo que pongamos: las agrupa en ese número


let subs = publisher.sink(receiveValue: { value in
    print("Recibido \(value)")
})

// Con este ejemplo lo que estamos viendo es cómo podemos filtrar, modificar, transformar las señales, de forma que podemos descartar las que no nos interesen

// Veamos otro ejemplo con el operador reduce (que va agrupando o acumulando todas las llamadas y las devuelve como una sola), y además con la opción de avisar cuando termine:
let publisher2 = [1,2,3,4,5,6,7,8,9].publisher
    .filter { $0 <= 5 }
    .map { "\($0)€" }
    .reduce("", { "\($0),\($1)" })


let subs2 = publisher2.sink {
    if case .finished = $0 {
        print("Ha terminado")
    }
} receiveValue: { value in
    print("Recibido \(value.dropFirst())")
}


//: [Next](@next)
