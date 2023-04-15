//: [Previous](@previous)

import UIKit

// TIPO RESULTADO, ESENCIAL EN COMBINE

// Es un tipo del sistema y está basado en las enumeraciones de carga, con valores asociados a cada caso: hay que indicar el tipo de dato para success y para failure, pero este segundo caso tiene que estar conformado al tipo Error
let a:Result<Int, URLError>

// Veamos un ejemplo concreto

enum ErroresSuma: Error {
    case arrayVacio, datoInvalido
    // así creamos nuestros propios errores
}

func sumaNumeros(nums:[Int]) -> Result<Int, ErroresSuma> {
    if nums.isEmpty {
        return .failure(.arrayVacio)
    }
    var suma = 0
    for num in nums {
        suma += num
    }
    return .success(suma)
}

let array = [1,2,3,34,4,5,6,6,7,8,6,3]
let suma = sumaNumeros(nums: array)
// La línea anterior ejecuta la función y devuelve un tipo Result, pero no sabemos de qué tipo hasta que miramos dentro. Esto se hace de dos formas: con switch o con if-case:
switch suma {
case .success(let sum):
    print("El resultado es \(sum)")
case .failure(let error):
    print("El error ha sido \(error)")
}

// La otra opción se basa en ignorar el éxito o el error, según nos interese:
// if-case funciona igual que el switch anterior, pero igualando al valor Result que queremos comprobar
if case .success(let sum) = suma {
    print("El resultado ha sido \(sum)")
}


//: [Next](@next)
