//: [Previous](@previous)

// CLOSURES QUE ESCAPAN, FUNDAMENTALES EN COMBINE

import UIKit

// Recordar que un closure es un bloque de código como una función, pero que es anónimo en sí mismo y en sus parámetros y puede almacenarse con let o var
// Ejemplo de función pasada a closure
func suma(a:Int, b:Int) -> Int {
    a + b
}
let f = { (a:Int, b:Int) -> Int in
    a + b
}
var array: [() -> Void] = []

// Un closure puede enviarse como parámetro a una función o a una clase:
class Test {
    var x = 10
    
    func noEscapa(completion: () -> Void) {
        //función que recibe un closure como parámetro de entrada, y el closure a su vez no recibe nada ni devuelve nada
        //y se dice que no escapa porque el closure no escapa al ámbito de la función que lo recibe, se ejecuta aquí dentro
        completion()
    }
    
    func escapa(completion: @escaping () -> Void) {
        //se dice que escapa cuando el closure no se ejecuta aquí, sino fuera del ámbito de la función que lo recibe como parámetro
        //ahora no ejecutamos completion, sino que se almacena en array que está fuera de la clase
        array.append(completion)
    }
    
    func testSync() {
        noEscapa(completion: { x = 20 })
        
        escapa(completion: {print("Hola")})
        escapa { [weak self] in //para no retener en memoria el valor de x
            self?.x = 15
            print(self?.x ?? 0)
        }
    }
}


//: [Next](@next)
