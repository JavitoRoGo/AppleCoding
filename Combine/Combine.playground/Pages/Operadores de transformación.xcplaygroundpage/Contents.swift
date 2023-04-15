//: [Previous](@previous)

import Combine
import Foundation

// OPERADORES DE TRANSFORMACIÓN

// Nos permiten transformar cualquier valor que emita un publicador, tanto el valor correcto como el error; e incluso transformar un publicador en otro

let publisher = ["Ola", "k", "Ase", "proGRamas", "o", "K", "ase"].publisher
let pub = publisher
    .map { $0.lowercased() }
// también podemos usar una ruta clave o keyPath para acceder a las propiedades de lo que va por el stream sin especificar un closure; así, lo anterior también podría hacerse de la siguiente manera:
    .map(\.localizedLowercase)

// Vamos ahora a suscbribirnos al publicador:
let subscriber = pub
    .sink(receiveValue: { print($0)} )

// Otro operador muy usado es flatMap, que nos permite recibir la salida tal cual del stream de un publicador, y transformar ese publicador en otro: nos devuelve un nuevo publicador con el final del publicador anterior

func newPublisher(value: String) -> CurrentValueSubject<String,Never> {
    //función que recibe un valor y devuelve un sujeto de valor actual, que hay que inicializar
    .init(value.uppercased())
}

let pub2 = publisher
    .map(\.localizedLowercase)
    .flatMap(maxPublishers: .max(3)) //así conseguimos limitar a 3 los eventos emitidos
        { newPublisher(value: $0) } //$0 es el valor String que viene del stream, y que entra en la función para devolver otro publicador

let subs = pub2.sink(receiveValue: { print($0) })


//: [Next](@next)
