import Foundation

// CLOSURES QUE LANZAN THROWS Y RETHROWS

enum errores: Error {
    case subcadenaNoEncontrada, cadenaVacia, subcadenaVacia
}

func posicionEn(cadena: String, sub: String, funcion: (String, String) throws -> Int) throws -> Int {
    //en este caso funcion es un closure como la propia función: recibe dos string y devuelve int
    if cadena.isEmpty {
        throw errores.cadenaVacia
    }
    if sub.isEmpty {
        throw errores.subcadenaVacia
    }
    
    return try funcion(cadena, sub)
}
let cadena1 = "One ring to rule them all"
let cadena2 = ""
do {
    try posicionEn(cadena: cadena1, sub: "ring") {
        guard let rango = $0.range(of: $1) else {
            throw errores.subcadenaNoEncontrada
        }
        return $0.distance(from: $0.startIndex, to: rango.lowerBound)
    }
} catch errores.subcadenaNoEncontrada {
    print("Subcadena no encontrada")
} catch errores.cadenaVacia {
    print("La cadena está vacía")
} catch errores.subcadenaVacia {
    print("La subcadena está vacía")
}
