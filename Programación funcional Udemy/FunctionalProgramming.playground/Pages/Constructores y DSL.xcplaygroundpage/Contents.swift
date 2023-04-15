//: [Previous](@previous)

import UIKit

// CONSTRUCTORES DE FUNCIONES Y DSL

// MARK: - EMPAQUETADORES DE PROPIEDADES

// Totalmente fundamentales en SwiftUI: son propiedades que actúan como instancias de clases auto-instanciadas y que derivan la mutabilidad fuera de los structs
// Por definición los structs son inmutables, no tienen estado, por lo que no permiten modificar sus propiedades de forma interna con métodos; en todo caso habría que añadir mutating a esos métodos
// La forma de resolver esto son los empaquetadores

struct FIFOStack<T> {
    private var storage: [T] = []
    
    mutating func addValue(value: T) {
        storage.insert(value, at: 0)
    }
    
    mutating func extractValue() -> T {
        storage.removeLast()
    }
}

// Vamos a crear un empaquetador, que se hace en una clase porque sí son mutables, tienen estado. El empaquetador lo creamos para modificar el struct sin hacer mutating sus funciones
@propertyWrapper
class FIFOStackClass<T> {
    private var storage: [T] = []
    
    var wrappedValue: T {
        get {
            storage.removeLast()
        }
        set {
            storage.insert(newValue, at: 0)
        }
    }
}

// Con esto ya creamos un struct normal y aplicamos el wrapper
struct FIFOApp {
    @FIFOStackClass private var stack: Int // como si fuera un wrapper de SwiftUI
    @FIFOStackClass private var stackS: String
    
    func addValueInt(value: Int) {
        stack = value
    }
    
    func extractInt() {
        stack
    }
}



// MARK: - CONSTRUCTORES DE RESULTADOS BÁSICOS

// DSL es lenguaje de dominio específico, que quiere decir que escribimos el código de forma que sea semánticamente y sintácticamente más fácil de leer y comprender

// Veamos qué es esto con una vista de SwiftUI
import SwiftUI
import PlaygroundSupport

struct Texts: View {
    var body: some View {
        VStack {
            Text("Hola")
            Text("Qué")
            Text("Tal")
            Text("Cómo estamos")
        }
    }
}

PlaygroundPage.current.setLiveView(Texts())

// La vista VStack hay que verla como una función o constructor de funciones que recibe desde 1 hasta 10 parámetros (4 en el ejemplo) y construye la vista

// Vamos a ver cómo construir nuestro constructor, pero que devuelva cadenas en lugar de vistas:
@resultBuilder
struct TextBuilder {
    static func buildBlock(_ components: String...) -> String {
        // función estática que recibe un parámetro components de tipo genérico llamado Component (que ajustamos a string en el ejemplo) y que además es variádico (los 3 puntos), que son los que pueden recibir varios parámetros sin especificar su número
        // y devuelve un único componente; hace como un reduce
        // lo que queremos hacer es coger todos los array de entrada que haya y devolver uno solo
        components.joined(separator: "\n")
    }
    // VStack hace algo parecido: coge las vistas que pongamos como parámetros, y construye una única vista de resultado
}

// Ahora creamos la función que permitirá usar el constructor, que pasa a ser un parámetro de entrada de la función
func makeText(@TextBuilder _ content: () -> String) -> String {
    // esta función tiene un parámetro de entrada que usa el TextBuilder, cuyo tipo es un closure que no recibe nada y devuelve String. Y a su vez la función devuelve un String
    // como estamos especificando TextBuilder (que es variádico), esta función puede recibir n parámetros de entrada
    content()
}

// La implementación sería:
let texto = makeText {
    "Hola"
    "Qué"
    "Tal"
    "Cómo estamos"
    // cada línea lo entiende como un closure de entrada para la función makeText
}
print(texto)



// MARK: - CONSTRUCTORES DE RESULTADOS AVANZADOS

// Se pueden incluir flujos de código como condicionales y bucles en los constructores, añadiendo una static func específica
// Al crear antes TextBuilder por obligación hay que incluir la func buildBlock, pero también hay otras funciones que perminten ampliar funcionalidades:
@resultBuilder
struct TextBuilder2 {
    static func buildBlock(_ components: String...) -> String {
        components.joined(separator: "\n")
    }
    
    static func buildOptional(_ component: String?) -> String {
        component ?? "" //devuelve cadena vacía si no hay entrada (o entrada nula)
    }
    
    static func buildEither(first component: String) -> String {
        component
    }
    static func buildEither(second compoment: String) -> String {
        compoment
    }
    
    static func buildArray(_ components: [String]) -> String {
        // permite crear arrays e implementar bucles for-in
        components.joined(separator: "-")
    }
}

func makeText2(@TextBuilder2 _ content: () -> String) -> String {
    content()
}
let cadenas = ["Hola", "K", "Ase"]
let texto2 = makeText2 {
    "Hola"
    if true {
        "Cierto"
    }
    "Adiós"
    for cadena in cadenas {
        cadena
    }
    "See you"
}
print(texto2)





//: [Next](@next)
