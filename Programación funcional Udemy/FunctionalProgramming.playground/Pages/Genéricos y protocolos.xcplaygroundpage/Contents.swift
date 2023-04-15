//: [Previous](@previous)

import UIKit

// GENÉRICOS Y PROTOCOLOS

// MARK: - CONCEPTO DE GENÉRICO

// Permiten crear una única función que reciba cualquier tipo de dato o comodín

func muestraAlgo(dato: Int) {
    print(dato)
}
func muestraAlgo(dato: String) {
    print(dato)
}
// Lo anterior es una función polimórfica, o versión de una misma función pero con distintos tipos de datos
// Si queremos hacer esto con varios tipos de datos, la forma no es crear las versiones sino usar los genéricos
// Pero primero habría que preguntarse qué característica esencial de cada tipo de dato es la que se usa. Pues en este ejemplo ninguna, porque lo que hacemos con el dato es pasarlo a la función print que recibe cualquier tipo de dato
func mostrarAlgo<T>(dato: T) {
    print(dato)
}
// Un genérico es un tipo de dato sin definir que se usa como hueco para implementarlo en la función, y que se va a declarar en tiempo de ejecución según lo que reciba. No tiene palabra reservada, así que puede ser T o lo que yo quiera poner



// MARK: - LLAMADA GENÉRICA DE RED

// Vamos a crear una llamada de URLSession genérica, que nos sirva para cualquier tipo de llamada de cualquier tipo de contenido que queramos construir y recuperar. Todo con closures genéricos como parámetros de entrada
// Se trata de crear una sola función capaz de recuperar un json con datos o una imagen

struct Empleados: Codable {
    let id: Int
    let username: String
    let first_name: String
    let last_name: String
    let gender: String
    let email: String
    let department: String
    let address: String
    let avatar: String
    let zipcode: String?
}

let imagenURL = URL(string: "https://i.blogs.es/d684a7/33258329033_159ddc3b1b_o/500_333.jpg")!
let jsonURL = URL(string: "https://applecoding.com/testData/EmpleadosData.json")!

// Primero haremos las funciones por separado, con la url y un callback; callback que escapa al ámbito de la función porque se va a ejecutar fuera del mismo, en la urlsession. En este primer caso lo que devuelve es la imagen
func getNetwork(url: URL, builder: @escaping (Data) -> UIImage?, callback: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            return
        }
        if response.statusCode == 200 { // toda va ok
            if let builded = builder(data) {
                callback(builded)
            }
        } else {
            print("Error \(response.statusCode)")
        }
    }.resume()
}
// Ya estaría la función, que solo nos serviría para llamar a una imagen. Pero tenemos una función que hace la llamada de red, y cuenta con un constructor para construir los datos, y el callback que hace lo que vayamos a hacer con la imagen
getNetwork(url: imagenURL) {
    UIImage(data: $0) // este es el builder, lo que inyecta para obtener builded
} callback: {
    print($0)
    $0
}

// ¿Cómo hacer esto mismo pero con genéricos, de forma que también llamemos al json que tiene otro constructor diferente?

func getNetworkGeneric<T>(url: URL, builder: @escaping (Data) -> T?, callback: @escaping (T) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            return
        }
        if response.statusCode == 200 { // toda va ok
            if let builded = builder(data) {
                callback(builded)
            }
        } else {
            print("Error \(response.statusCode)")
        }
    }.resume()
}

//Ahora funciona con imagen y con json
getNetworkGeneric(url: imagenURL) {
    UIImage(data: $0) // constructor para UIImage
} callback: {
    print($0)
    $0
}
getNetworkGeneric(url: jsonURL) { data in
    try? JSONDecoder().decode([Empleados].self, from: data) // cambia el constructor: este es el de json
} callback: { empleados in
    print(empleados.first!)
}



// MARK: - GENÉRICOS CONDICIONALES

// No siempre cualquier tipo de dato es aceptado en una función con genéricos. A través de los protocolos podemos asegurar que los genéricos cumplan ciertas condiciones o acepten determinados tipos
// Se trata de limitar el genérico a que cumpla una determinada condición. Y la forma en Swift de hacerlo es con protocolos
// Para verlo, hagamos un ejemplo que crea una función que nos devuelve el índice que ocupa un número en el array (esto es puede hacer con firstIndex, pero creamos una función para el ejemplo)

var array = [1,3,5,6,7,6,5,6,5]
var arrayS = ["dkdk", "alñkdsjf", "añklsdjf", "lasdjf", "añlskjdf", "laksjdflj"]

func indice<T: Equatable>(valor: T, array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valor {
            return index
        }
    }
    return nil
}
// Si pusiéramos solo indice<T> daría error porque un genérico no permite la igualdad == o !=. Pero al restringirlo o conformarlo al protocolo Equatable, ya solo permite tipos de datos que sean comparables, con lo que la comparación == no da problema
indice(valor: 5, array: array)
indice(valor: "lasdjf", array: arrayS)



// MARK: - COMPOSICIÓN DE FUNCIONES

// Usar un operador para "sumar" funciones como si fueran una sola; hacer que la salida de una función sea la entrada de otra

func generateNumber(max: Int) -> Int {
    Int.random(in: 1...max)
}
func spell(number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "es")
    formatter.numberStyle = .spellOut
    return formatter.string(for: number) ?? ""
}

generateNumber(max: 15)
spell(number: 123)

// ¿Cómo componer las dos funciones? Se hace usando un operador, que podría unir varias funciones
// Podemos generar operadores personalizados con la palabra reservada infix, que crea un operador con dos parámetros: uno a la derecha y otro a la izquierda del operador
// También usamos un grupo de precedencia, que indica el orden o prioridad de los operadores (la multiplicación tiene más precedencia que la suma)

precedencegroup CompositionPrecedence {
    associativity: left // empieza por la izquierda
}
infix operator >>>: CompositionPrecedence // >>> es nuestro nombre para el operador

func >>><T,U,V>(lhs: @escaping (T) -> U, rhs: @escaping (U) -> V) -> (T) -> V {
    // func que recibe a la izquierda T y devuelve U, y a la derecha recibe U y devuelve V
    // y toda la función recibe T y devuelve V, o sea, la composición de las dos funciones lhs y rhs
    { rhs(lhs($0)) } // la 2ª función recibe la 1ª como parámetro, sobre el dato original $0 que recibe la 1ª
}
let spellOutRandom = generateNumber >>> spell
print(spellOutRandom(100))



// MARK: - MEMORIZACIÓN AUTOMÁTICA

// Integrar memorización de funciones automática y genérica que sirve para cualquier algoritmo recursivo (como sería calcular la secuencia de Fibonacci o el factorial de un número)
// Veamos un ejemplo para calcular la secuencia de Fibonacci y su valor phi, primero con tipos específicos y luego cambiando por genéricos

var fibonacciMemo = Dictionary<Int, Double>()
func fibonacciMM(n: Int) -> Double {
    if let result = fibonacciMemo[n] {
        return result
    }
    let result = n < 2 ? Double(n) : fibonacciMM(n: n - 1) + fibonacciMM(n: n - 2)
    fibonacciMemo[n] = result
    return result
}
let phiMM = fibonacciMM(n: 45) / fibonacciMM(n: 44)

/*
func memorize(body: @escaping ((Int) -> Double, Int) -> Double) -> (Int) -> Double {
    función que recibe como entrada una función (que recibe Int y devuelve Double) y un entero, y devuelve Double. Y toda la función devuelve una función que recibe Int y devuelve Double
 Recordar que escaping es porque el closure de entrada debe escapar al ámbito de la función, debe poder ejecutarse fuera, en otro sitio
 A continuación cómo sería con genéricos
}
*/

func memorize<T: Hashable, U>(body: @escaping ((T) -> U, T) -> U) -> (T) -> U {
    var memo = [T: U]() // diccionario para ir almacenando los valores y que sea más rápido el cálculo
    var result: ((T) -> U)!
    result = { key in
        if let q = memo[key] {
            return q
        }
        let r = body(result, key)
        memo[key] = r
        return r
    }
    return result
}
// La aplicación sería:
let fibMemoAuto = memorize { fibonacci, number in
    number < 2 ? number : fibonacci(number - 1) + fibonacci(number - 2)
}
fibMemoAuto(55)

// Con la función factorial sería:
let factorial = memorize { factorial, x in
    x == 0 ? 1 : x * factorial(x - 1)
}
factorial(15)






//: [Next](@next)
