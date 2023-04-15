//: [Previous](@previous)

import Combine
import Foundation

// SUSCRIPTORES

// Es importante saber cómo los suscriptores se retienen en memoria para poder seguir ejecutándose dentro de un proceso asíncrono. Es decir, hay que almacenarlo en algún lugar que lo mantenga vivo en memoria.
// Recordar que retener un suscriptor rentendrá también a su correspondiente publicador.
// Veamos esto con un ejemplo

class ClasePublicadora {
    //creamos un futuro en una variable calculada, ya tenemos el publicador
    var futuro: Future<String, Never> {
        Future<String, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                promise(.success("OK"))
            }
        }
    }
    
    //función que recoja el publicador y lo ponga en un suscriptor
    func start() {
        //haciendo esto la constante solo existe dentro del ámbito de la función, y muere fuera de este ámbito, por lo que no funcionará y no accederá al valor futuro.
        //para resolver esto creamos la variable subscriber y la otra función
        let subscription = futuro.sink { value in
            print("\(value)")
        }
    }
    
    var subscriber: AnyCancellable? // el suscriptor tiene que estar SIEMPRE retenido en memoria
    
    func start2() {
        subscriber = futuro.sink { value in
            print(value)
        }
    }
    
    // El suscriptor podemos almacenarlo asignándolo a una variable como en la función anterior, o podemos almacenarlo en un conjunto usando una propiedad específica:
    var subscribers = Set<AnyCancellable>()
    func start3() {
        futuro.sink { value in
            print(value)
        }
        .store(in: &subscribers)
    }
    
    // Como resumen, vamos a crear de una sola vez, de forma decclarativa, un publicador-operador-suscriptor y lo vamos a almacenar:
    func resumen() {
        [1,3,5,7,9].publisher
            .map { "\($0)€" }
            .sink { print($0)}
            .store(in: &subscribers)
    }
}

let clase1 = ClasePublicadora()
clase1.start() //este no hace nada
clase1.start2() // este sí imprime "OK"
clase1.start3() // este también imprime
clase1.resumen()


//: [Next](@next)
