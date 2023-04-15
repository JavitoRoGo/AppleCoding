//: [Previous](@previous)

import UIKit

// FUNCIONES DE ORDEN MÁS ALTO USADAS EN COMBINE

// Estas funciones son usadas por los operadores para transformar la señal del stream
// Veamos algunos ejemplos de estas funciones:

let array = [1,2,3,4,5,6,4,5,6,7,9,7,9,0,8,6,7,8,3,4,6]
let array2 = ["Hola", "Adiós", "Good Bye", "Hello"]
let arrayPics = ["Alias", "Alien", "BasicInstinct", "Paquito", "Aliens", "AmazingStories", "BoysFromBrazil", "AmericanTail"]

// Map: transforma los elementos según el closure que le digamos
let arrayCadena = array.map({ num -> String in
    "\(num)"
})
// Lo anterior puede hacerse todavía más simplificado:
let arrayCadenaSimple = array.map { "\($0)" }
arrayCadenaSimple


// Filter: filtra los datos
let arrayMenor6 = array.filter { $0 <= 6 }
arrayMenor6


// CompactMap: transforma y devuelve los resultados no nulos, y además lo hace no opcional
let arrayImagen = arrayPics.compactMap { UIImage(named: "\($0).jpg") }
arrayImagen


// Concatenación de operadores
let arrayImagen2 = arrayPics
    .compactMap { UIImage(named: "\($0).jpg") }
    .filter { $0.size.width == 100 }
arrayImagen2


// Reduce: hacer un valor reducido
let reducido = array.reduce(0,+)
reducido

// Ejemplo de varias
let csv = array
    .filter { $0 <= 6 }
    .map { "\($0)" }
    .reduce("") { "\($0),\($1)" }
    .dropFirst() //para eliminar la primera coma que añade
csv


//: [Next](@next)
