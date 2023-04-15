import Foundation

// FUNCIONES
// Es código encapsulado para llamarlo siempre que lo necesitemos, y no estar repitiendo las mismas instrucciones
func alerta() {
    let titulo = "Alerta"
    let mensaje = "Ha pulsado usted el botón"
    print("\(titulo): \(mensaje)")
}
alerta()

// Parámetros de entrada (estos parámetros son siempre constantes, y hay que declarar el tipo porque no funciona la inferencia)
func alerta2(mensaje: String) {
    let titulo = "Alerta"
    print("\(titulo): \(mensaje)")
}
alerta2(mensaje: "Gracias por pulsar")
alerta2(mensaje: "Se ha entrado al sistema")

func alerta3 (mensaje: String, titulo: String) {
    print("\(titulo): \(mensaje)")
}
alerta3(mensaje: "Se ha entrado al sistema", titulo: "Información")

// Parámetros de salida, para devolver un resultado y utilizarlo
var test = [2,5,8,20,40,1,4,18]
func sumar(numeros: [Int]) -> Int {
    if numeros.isEmpty {
        return 0
    }
    var resultado = 0
    for numero in numeros {
        resultado += numero
    }
    return resultado
}
let suma = sumar(numeros: test)
sumar(numeros: []) //devuelve 0, la función no llega a evaluar el bucle for porque sale por el return anterior

// También se puede devolver más de un valor de la función, que es como una tupla:
func sumaMultiple(numeros: [Int]) -> (sum:Int, mult:Int) {
    if numeros.isEmpty {
        return (0,0)
    }
    var resultado1 = 0
    var resultado2 = 1
    for numero in numeros {
        resultado1 += numero
        resultado2 *= numero
    }
    return (resultado1, resultado2)
}
let resultado = sumaMultiple(numeros: test) //devuelve una tupla
resultado.sum
let result = sumaMultiple(numeros: test).0 //devuelve un Int
let result2 = sumaMultiple(numeros: test).mult
let (sum, mult) = sumaMultiple(numeros: test)

// Polimorfismo o sobrecarga de funciones, creando versiones de la función para diferentes tipos de datos
// Se trata de usar la misma función, con el mismo nombre de función, pero con diferentes tipos de datos:
let test2 = [5.4, 2.3, 10.65, 3.1415, 17.32]
func sumaMultiple(numeros: [Double]) -> (sum:Double, mult:Double) {
    if numeros.isEmpty {
        return (0.0,0.0)
    }
    var resultado1 = 0.0
    var resultado2 = 1.0
    for numero in numeros {
        resultado1 += numero
        resultado2 *= numero
    }
    return (resultado1, resultado2)
}
sumaMultiple(numeros: test2)
//simplemente hemos creado la misma función pero cambiando solo el tipo de dato, y ya funciona. Además, xcode sabe qué versión de la función utilizar en base a la inferencia de tipo
//es más, se pueden crear versiones de la función simplemente cambiando el número de parámetros o tipo de datos, e incluso el número de las salidas, con todas las combinaciones que se nos ocurran:
func sumaMultiple(numeros: [Int], operacion: String) -> Int {
    var resultado = 0
    if operacion == "*" || operacion == "/" {
        resultado = 1
    }
    for numero in numeros {
        switch operacion {
        case "+": resultado += numero
        case "-": resultado -= numero
        case "*": resultado *= numero
        case "/": resultado /= numero
        default: ()
        }
    }
    return resultado
}
sumaMultiple(numeros: test, operacion: "*")

// Parámetros externos y placeholder
// Se puede usar un nombre para el parámetro fuera de la función (a la hora de "pedirlo" para ejecutarla) y otro nombre interno, para tarbajar con él dentro de la función
// Y se puede no usar un nombre externo usando el placeholder
func sumaMultiple2(_ numeros: [Int], signo operacion: String) -> Int {
    var resultado = 0
    if operacion == "*" || operacion == "/" {
        resultado = 1
    }
    for numero in numeros {
        switch operacion {
        case "+": resultado += numero
        case "-": resultado -= numero
        case "*": resultado *= numero
        case "/": resultado /= numero
        default: ()
        }
    }
    return resultado
}
sumaMultiple2(test, signo: "*")

// Parámetros por defecto, asignando un valor a un parámetro de entrada
func sumaMultiple3(numeros: [Int], operacion: String = "+") -> Int {
    var resultado = 0
    if operacion == "*" || operacion == "/" {
        resultado = 1
    }
    for numero in numeros {
        switch operacion {
        case "+": resultado += numero
        case "-": resultado -= numero
        case "*": resultado *= numero
        case "/": resultado /= numero
        default: ()
        }
    }
    return resultado
}
sumaMultiple3(numeros: test)
//hace la suma por defecto porque no lo hemos especificado, y coge por tanto el valor por defecto

// Hacer que los parámetros de entrada sean variables: parámetros de entrada y salida
func sumaMultiple4(numeros:inout [Int], operacion: String = "+") -> Int {
    var resultado = 0
    if operacion == "*" || operacion == "/" {
        resultado = 1
    }
    for numero in numeros {
        switch operacion {
        case "+": resultado += numero
        case "-": resultado -= numero
        case "*": resultado *= numero
        case "/": resultado /= numero
        default: ()
        }
    }
    numeros.append(resultado)
    return resultado
}
let result4 = sumaMultiple4(numeros: &test, operacion: "*")
test

// Funciones variádicas, con diferentes números de parámetros o valores
// En este caso, el parámetro de entrada sería un Int y no [Int], pero lo hacemos variádico y podemos agregar el número de datos que queramos
func sumaMultiple5(numeros: Int..., operacion: String = "+") -> Int {
    var resultado = 0
    if operacion == "*" || operacion == "/" {
        resultado = 1
    }
    for numero in numeros {
        switch operacion {
        case "+": resultado += numero
        case "-": resultado -= numero
        case "*": resultado *= numero
        case "/": resultado /= numero
        default: ()
        }
    }
    return resultado
}
let result5 = sumaMultiple5(numeros: 4,7,9,15,20,16,4,7, operacion: "-")
// OJO: no se ha modificado el código de la función, porque aunque un parámetro variádico no es un array, es un tipo de colección, y por eso nos permite hacer el bucle for in

// Defer o bloques diferidos: es un bloque de código que se ejecuta siempre al final de la función, siempre, independientemente de cuál sea la salida de la función
// En el siguiente ejemplo hay 4 posibles salidas (return) de la función en función del valor booleano de cada error, pero el código defer se va a ejecutar siempre y al final:
func conexionFacebook() {
    let errorInicio = true
    let errorValidacion = false
    let errorConexion = false
    
    defer {
        print("Cierra la conexión con Facebook")
    }
    
    print("Inicio de conexión con Facebook")
    if errorInicio {
        print("Error de inicio")
        return
    }
    if errorValidacion {
        print("Error en la validación")
        return
    }
    if errorConexion {
        print("Error en la conexión")
        return
    }
    print("He conectado a Facebook")
}
conexionFacebook()
