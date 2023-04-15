import UIKit

var greeting = "Hello, playground"

/*
 La función map usa un closure como parámetro de entrada para modificar los datos a los que apliquemos map.
 Se usa en colecciones de datos, y lo que hace es devolver una nueva colección pero aplicando la transformación que le indiquemos a través del closure.
 Ejemplo:
 */
let array = [2,5,6,7,8,9,4,4,3,9,5,6,6,4,3]
let arrayCadenas = array.map { (num: Int) -> String in
    return "\(num)€"
}
/*
 La expresión anterior puede simplificarse más todavía de la siguiente forma:
 - Al ser una sola instrucción podemos omitir la palabra return
 - map se define con tipos genéricos, por lo que puede inferir el tipo según el contexto, así que podemos ahorrarnos decirle que devuelva el tipo String porque ya lo infiere
 - Se puede quitar la especificación de la entrada porque en la propia definición de map se especifica que recibe enteros, y dejamos solo el nombre
 - Podemos incluso quitar el nombre del parámetro num y usar el nombre de parámetro por defecto: signo $ seguido por el número de la posición que ocupa: $0, $1(para un segundo parámetro)...
 - Y al quitar el tipo de entrada y su nombre podemos quitar también la palabra clave in
 
 Y quedaría de la siguiente forma:
 */
let arrayCadenasSimple = array.map {
    "\($0)€"
}

//MARK: - FUNCIONES COMO TIPOS DE DATOS - CIUDADANOS DE PRIMERA CLASE

func sumar(a: Int, b: Int) -> Int {
    a + b
}
// Podemos asignar la función a una constante (valor sin estado)
let suma1 = sumar(a: 3, b: 5) // tipo Int
// Pero también podemos asignar la propia función:
let suma = sumar
// En este caso, el tipo de suma es (Int, Int) -> Int

// Ahora podemos invocar al closure que está dentro de la función a través de la constante, pasando los parámetros sin nombre
suma(3, 5)


// MARK: - FUNCIONES COMO PARÁMETROS DE ENTRADA DE OTRAS FUNCIONES

func restar(a: Int, b: Int) -> Int {
    a - b
}

func calculo(numeros: [Int], algoritmo: (Int, Int) -> Int) -> Int? {
    guard var resultado = numeros.first else { return nil }
    for numero in numeros.dropFirst() { //quitamos el primer elemento porque ya está en resultado
        resultado = algoritmo(resultado, numero)
    }
    return resultado
}
calculo(numeros: array, algoritmo: sumar) //el algoritmo es la función sin los parámetros
calculo(numeros: array, algoritmo: restar)


// MARK: - CLOSURES O FUNCIONES ANONIMAS

calculo(numeros: array, algoritmo: { (a: Int, b: Int) -> Int in
    a + b
})
// Se usa en este caso un closure como parámetro de entrada de la función


// MARK: - INFERENCIA EN CLOSURES

// Veamos como reducir el código de la expresión siguiente usando la inferencia de tipos:

 calculo(numeros: array, algoritmo: { (a: Int, b: Int) -> Int in return a + b })
 
// Como el closure devuelve una línea simple podemos quitar return; y también puede inferir que tiene que devolver un entero, por la operación en sí y porque está especificado en la definición de la función "calculo", así que podemos quitar también el tipo de la devolución:
calculo(numeros: array, algoritmo: { (a: Int, b: Int) -> Int in a + b })
calculo(numeros: array, algoritmo: { (a: Int, b: Int) in a + b })

// En la firma de la función ya viene definido también el tipo Int de los parámetros de entrada del closure, así que los podemos quitar porque van implícitos:
calculo(numeros: array, algoritmo: { (a, b) in a + b })

// Se puede usar la notación simple de los parámetros de entrada y quitar los nombres de a y b. Estos nombres no están en la firma de la función, en la que sólo se especifica el tipo; pero al usar la función esos nombres los ponemos nosotros para usarlos después y hacer la suma. Por tanto, se pueden quitar y sustituir por $0, $1...
// Y además, al no haber ya nombre de parámetros de entrada, se puede quitar también la palabra clave "in":
calculo(numeros: array, algoritmo: { $0 + $1 })

// Closure de cierre: como el últimpo parámetro de entrada de la función es el closure, se puede eliminar el nombre de dicho parámetro, cerrando ahí la función y poniendo el closure fuera:
calculo(numeros: array) { $0 + $1 }
