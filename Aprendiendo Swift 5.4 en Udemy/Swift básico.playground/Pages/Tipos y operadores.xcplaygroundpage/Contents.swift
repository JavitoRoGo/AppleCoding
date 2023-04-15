import UIKit

var greeting = "Hello, playground"

//: Con dos puntos en los comentarios el texto se convierte en MarkDown como texto enriquecido, y podemos aplicarle propiedades con su propio código: **para negrita**, *cursiva*, etc. Buscar los códigos

// Pulsando option al clicar en mostrar un nuevo editor lo muestra debajo en lugar de a la derecha

// Live view es como si fuera el simulador, muestra la pantalla de la app. Solo funciona en playgrounds de tipo single view


// ALIAS DE TIPOS
/*
 Se usa para simplificar o, más bien, explicar el código, para que sea más fácil de leer
 Lo que hace es asignar un nombre elegido por nosotros a un tipo de dato de Swift, de forma que podemos usar nuestro nombre en lugar de string, int o lo que sea
 En el siguiente ejemplo se declara una segunda constante usando el alias o nuestro nombre en lugar del tipo "oficial" de swift
 */
let cadenaUno: String = "Swift"
typealias Cadena = String
let cadenaDos: Cadena = "Swift 3"
typealias Numerito = Int
let miNumero: Numerito = 7


// OPERADORES BÁSICOS
// El operador resto o % funciona con enteros y lo que nos devuelve es el resto de la división:
let a = 2
let b = 3
a % b // devuelve 2: 2/3=0+2
b % a // devuelve 1: 3/2=1+1


// Operador de igualdad por referencia: === y !==
// Se usa para clases, para saber si dos instancias apuntan a la misma referencia o clase:
let c = UILabel()
let d = c
d === c // devuelve true porque tienen la misma referencia
let e = UILabel()
d === e // devuelve false porque no apuntan a la misma referencia a pesar de ser dos instancias de UILabel


// Operador ternario condicionado
// De una vez hacemos la comparación, y damos el resultado para true y para false. Sirve para que devuelva un valor determinado según la condición, en lugar de solo true o false:
a == b ? 0 : 1 // si se cumple la condición devuelve 0; si la condición es false devuelve 1
a < b ? "a es menor que b" : "a no es menor que b"
// Con este operador se pueden anidar las condiciones:
a == b ? "a es igual a b" : a < b ? "a es menor que b" : a > b ? "a es mayor que b" : "nada"


// Operadores lógicos: and, or, not
let i = 2
i > 0 && i < 10 //devuelve true porque TODAS las condiciones son true: se dice que es verdadero exclusivo
let j = 0
j < 0 || j > 0  //devuelve false porque NINGUNA de las condiciones es true: falso exclusivo
!(i == 0) //devuelve true. Es lo mismo que poner i != 0



// VALORES ALEATORIOS
// Se accede con una propiedad de los tipos de datos: random
Int.random(in: 0...10)
Double.random(in: 0..<10)
Bool.random()
let cadena = "Hola estoy aquí"
cadena.randomElement()
let cadenaDesordenada = cadena.shuffled()
