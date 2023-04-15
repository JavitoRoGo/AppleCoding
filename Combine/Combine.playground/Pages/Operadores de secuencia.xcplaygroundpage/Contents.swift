//: [Previous](@previous)

import Combine
import Foundation

// OPERADORES DE SECUENCIA

// Nos permiten trabajar con la secuencia de datos emitidos, con los streams

let publisher = [5,3,6,4,7,6,8,7,7,4].publisher
publisher
    .min()
    .sink { value in
        print("Mínimo \(value)")
    }

publisher
    .max()
    .sink { value in
        print("Máximo \(value)")
    }

// Al min y max se le puede poner un closure para acceder a alguna propiedad
let pub2 = ["Hola", "K", "ase"].publisher
pub2
    .min { $0.count < $1.count }
    .sink { value in
        print("Mínimo caracteres \(value)")
    }

pub2
    .max { $0.count < $1.count }
    .sink { value in
        print("Máximo caracteres \(value)")
    }

// Otros operadores de ubicación son first y last
publisher
    .first()
    .sink { value in
        print("Primero \(value)")
    }

publisher
    .last()
    .sink { value in
        print("Último \(value)")
    }


// También podemos coger una salida concreta según su índice. O un rango
publisher
    .output(at: 2)
    .sink { value in
        print("Índice 2: \(value)")
    }

publisher
    .output(in: 2...4)
    .sink { value in
        print("Índice 2 al 4: \(value)")
    }

publisher
    .count()
    .sink { value in
        print("Total valores emitidos: \(value)")
    }



//: [Next](@next)
