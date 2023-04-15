//: [Previous](@previous)

import Foundation

// TIPOS DE FUNCIONES

// FUNCIONES PURAS

// Son aquellas que devuelven el mismo resultado al recibir los mismos parámetros de entrada: no tienen dependencias externas y no tienen estado. Dicho de otra forma, no mutan o alternan aquello sobre lo que se aplica
var a = 1
func suma(b: Int) -> Int {
    a + b
}
// El ejemplo anterior NO es una función pura porque depende de un valor externo: si "a" cambia, el valor devuelto por la función será diferente
// Debemos tender a usar funciones puras porque son mejores para su reutilización

// Veamos un ejemplo de una extensión para String que añade un sufijo a una cadena, siempre y cuando no lo tenga:
extension String {
    mutating func addSuffix(suffix: String) {
        guard !hasSuffix(suffix) else { return }
        append(suffix)
    }
}
/*
 Esta función anterior usa mutating porque está modificando el propio String (que es struct y por definición no tiene estado y no es mutable)
 Lo primero que hace es comprobar que el sufijo no esté ya contenido en la cadena, y si no está luego lo añade MODIFICANDO self o la propia cadena
 Por tanto, NO es una función pura, SÍ tiene estado y sí modifica aquello sobre lo que se aplica
 
 La siguiente función SÍ es una función pura y SIN estado y NO modifica la propia cadena o self, porque lo que hace es devolver un NUEVO String
 */
extension String {
    func addingSuffix(suffix: String) -> String {
        guard !hasSuffix(suffix) else { return self }
        return appending(suffix) // OJO: no es lo mismo append que appending
    }
}


// MARK: - FUNCIONES ANIDADAS

// Son funciones dentro de funciones. Así de simple
// El siguiente ejemplo es una función que suma o resta 2 en función de un parámetro Bool:

func masMenos2(num: Int, masMenos: Bool) -> Int {
    func mas(_ num: Int) -> Int {
        num + 2
    }
    
    func menos(_ num: Int) -> Int {
        num - 2
    }
    
    return masMenos ? mas(num) : menos(num)
}
masMenos2(num: 3, masMenos: true)
masMenos2(num: 3, masMenos: false)

/*
 El anidar funciones sirve para segmentar código o para reutilizar mejor el código
 Una ventaja de anidar funciones tiene que ver con el ámbito: las funciones anidadas son privadas de la función principal y solo existen dentro de ellas
 Es como tener métodos dentro de la función, como ocurre con las clases o struct
 */



// MARK: - FUNCIONES PARCIALIZADAS

// El siguiente paso es devolver funciones como resultado de una función, la parcialización
// Como ejemplo se va a parcializar la función anterior masMenos2

func cuenta2(masMenos: Bool) -> (Int) -> Int {
    func mas(_ num: Int) -> Int {
        num + 2
    }
    
    func menos(_ num: Int) -> Int {
        num - 2
    }
    
    return !masMenos ? mas : menos //se invierte la condición con ! para que sea una cuenta atrás
}
var valor = 16
let count = cuenta2(masMenos: valor > 0)
while valor != 0 {
    valor = count(valor)
}



// MARK: - RECURSIVIDAD

// Funciones que se llaman a sí mismas para obtener un resultado, normalmente acumulativo
// PERO OJO: tienen que tener una salida, porque si no creamos un bucle infinito
// Ejemplo para calcular el factorial

func factorial(n: Int) -> Int {
    // n * factorial(n: n - 1) ejemplo de bucle infinito
    n == 0 || n == 1 ? 1 : n * factorial(n: n - 1)
}
factorial(n: 5)
/*
 Esta función no es muy óptima porque tiene que acumular en memoria cada uno de los pasos intermedios y luego resolverlos hacia arriba cuando llega a la salida. Lo que hace el ejemplo anterior es:
 5 * factorial(4)
 5 * 4 * factorial(3)
 5 * 4 * 3 * factorial(2)
 5 * 4 * 3 * 2 * factorial(1)
 5 * 4 * 3 * 2 * 1
 
 Una alternativa más óptima de hacerlo es usar un parámetro intermedio o de ayuda, de la siguiente forma:
 */
func factorialTail(n: Int, currentFactorial: Int = 1) -> Int {
    n == 0 ? currentFactorial : factorialTail(n: n - 1, currentFactorial: n * currentFactorial)
}
factorialTail(n: 5)



// MARK: - ÁRBOLES BINARIOS

// Se usa para buscar datos de forma más óptima, mediante enums recursivos en una función recursiva
// Ver ejemplo con gráfico en el vídeo para entender el ejemplo de árbol y nodo

enum Arbol<Int> { //tipo genérico Int
    case Vacio
    indirect case Nodo(Arbol<Int>, Int, Arbol<Int>)
}
let n4: Arbol = .Nodo(.Vacio, 4, .Vacio)
let n7: Arbol = .Nodo(.Vacio, 7, .Vacio)
let n13: Arbol = .Nodo(.Vacio, 13, .Vacio)

let n1: Arbol = .Nodo(.Vacio, 1, .Vacio)
let n6: Arbol = .Nodo(n4, 6, n7)
let n14: Arbol = .Nodo(n13, 14, .Vacio)

let n3: Arbol = .Nodo(n1, 3, n6)
let n10: Arbol = .Nodo(.Vacio, 10, n14)

let root: Arbol = .Nodo(n3, 8, n10)

func contiene(inicio: Arbol<Int>, dato: Int) -> Bool {
    guard case let .Nodo(izq, num, der) = inicio else { return false }
    if dato == num {
        return true
    } else if contiene(inicio: izq, dato: dato) {
        return true
    } else if contiene(inicio: der, dato: dato) {
        return true
    } else {
        return false
    }
}

contiene(inicio: root, dato: 14)



// MARK: - FUNCIONES QUE ESCAPAN

// Funciones que guardan elementos externos para usarlos luego en un entorno asíncrono

var arrayC: [() -> ()] = [] //array de closures que no reciben nada y no devuelven nada
let closure = { print("Hola") }
arrayC.append(closure)
arrayC.append {
    print("Adiós")
}

class Test {
    var x = 10
    func completado(completion: () -> ()) {
        completion()
        // esta función NO escapa porque el parámetro capturado se ejecuta dentro del propio ámbito de la función
    }
    func completadoE(completion: @escaping () -> ()) {
        arrayC.append(completion)
        // esta función sí escapa porque el parámetro completion no se ejecuta dentro del ámbito de la función
        // estos closures se marcan con @escaping
    }
    func test() {
        completado {
            x = 20
        }
        completadoE {
            print("Hola")
        }
        completadoE {
            self.x = 25
            // se usa self para capturar semánticamente el valor en memoria
        }
    }
}
let test1 = Test()
test1.x //10
test1.test()
test1.x //20



// MARK: - MEMORIZACIÓN DE FUNCIONES

/*
 La memorización en funciones o lectura de datos en caché es mucho más rápido y eficiente que calcular ese dato cada vez que lo necesitamos
 Veamos un ejemplo con una función recursiva para obtener el valor de una posición determinada de la secuencia de Fibonacci
 */
func fibonacci(pos: Int) -> Double {
    pos < 2 ? Double(pos) : fibonacci(pos: pos - 1) + fibonacci(pos: pos - 2)
}
fibonacci(pos: 6) // no es eficiente porque da 25 vueltas solo para la posición 26
// Esto se resuelve memorizando los datos, por ejemplo en un diccionario
var fibonacciMemo: [Int: Double] = [:]
func fibonacciM(pos: Int) -> Double {
    if let result = fibonacciMemo[pos] {
        return result
    }
    let result = pos < 2 ? Double(pos) : fibonacciM(pos: pos - 1) + fibonacciM(pos: pos - 2)
    fibonacciMemo[pos] = result
    return result
}
fibonacciM(pos: 6) // solo 7 vueltas y más rápido
/*
 Si tenemos muchos cálculos en nuestro código tenemos que memorizarlos porque el acceso a memoria es infinitamente más rápido y eficiente
 */


//: [Next](@next)
