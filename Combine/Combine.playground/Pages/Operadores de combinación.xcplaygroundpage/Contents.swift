//: [Previous](@previous)

import Combine
import Foundation

// OPERADORES DE COMBINACIÓN Y COMPARTICIÓN

// Permiten combinar lo que emiten varios publicadores, compartir sus resultados y aprovechar el trabajo de cada uno de los componentes

let pub1 = [1,2,3].publisher
let pub2 = [4,5,6].publisher

pub1
    .append(pub2)
// añade el segundo al primero: hasta que el primero no termina y emite el finished no empieza a recibir el segundo
    .sink { value in
        print("Append: \(value)")
    }

pub1
    .prepend(pub2)
// lo contrario de append
    .sink { value in
        print("Prepend: \(value)")
    }

// También está la mezcla o merge, de hasta 8 elementos del mismo tipo:
let sub1 = PassthroughSubject<Int,Never>()
let sub2 = PassthroughSubject<Int,Never>()
sub1
    .merge(with: sub2)
    .sink { completion in
        if case .finished = completion {
            print("Ha terminado")
        }
    } receiveValue: { value in
        print("Merge: \(value)")
    }
//sub1.send(1)
//sub1.send(2)
//sub2.send(3)
//sub1.send(4)
//sub2.send(5)
//sub1.send(6)
//sub1.send(7)
//sub1.send(completion: .finished)
//sub2.send(8)
//sub2.send(completion: .finished)
// Tienen que terminar los dos para que se emita la finalización de ambos
// Se han comentado las líneas anteriores para que funcione el ejemplo siguiente


// Veamos otro operador: suscribe al último valor de un publicador adicional y publica una tupla con las señales de ambos
// Al devolver una tupla, pueden incluirse distintos tipos de valores
let sub3 = PassthroughSubject<String,Never>()
sub3
    .combineLatest(sub2) //coge el último valor que emita sub2
    .sink { value in
        print("Combine Latest: \(value)")
    }

sub1.send(1)
sub1.send(2)
sub2.send(3)
sub1.send(4)
sub2.send(5)
sub1.send(6)
sub1.send(7)
sub1.send(completion: .finished)
sub2.send(8)
sub2.send(completion: .finished)

sub3.send("9")
sub3.send("10")
sub3.send("11")


// Otro publicador más en ZIP: es como el merge, pero en este caso no emite hasta que todos los publicadores involucrados hayan emitido su valor
// Podemos combinar hasta 4 publicadores, y pueden ser de distinto tipo, porque hasta que no haya una señal de todos, no va a emitir. También emite una tupla
let sub5 = PassthroughSubject<String,Never>()
let sub6 = PassthroughSubject<Int,Never>()
sub5
    .zip(sub6)
    .sink { value in
        print("ZIP: \(value)")
    }

sub5.send("a")
sub5.send("b")
sub6.send(3)
sub5.send("c")
sub6.send(5)
// El resultado de esto son dos líneas: ZIP: ("a", 3) y ZIP: ("b", 5). Esto es así porque emite cuando tiene el par de valores de sub5 y sub6, por eso no hay la tercera línea con la letra c
// Esto es muy práctico en el siguiente ejemplo: estamos recibiendo 3 tipos de información de una web en diferentes tiempos, pero no recibimos el resultado hasta que tengamos la terna o el trío de valores



//: [Next](@next)
