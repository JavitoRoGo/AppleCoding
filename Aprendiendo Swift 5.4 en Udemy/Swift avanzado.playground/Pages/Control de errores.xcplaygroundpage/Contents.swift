import UIKit

// CONTROL DE ERRORES
// Do-try-catch: se crea un ámbito do con un try, que prueba la parte que puede dar el error; y con el catch se captura ese error. Hay que usarlo cuando carguemos una función que devuelva throw
// Ejemplo que intentar hacer la carga de un archivo datos.plist
do {
    //lo primero es crear la ruta para llegar al fichero a cargar
    let rutaLectura = Bundle.main.path(forResource: "datos", ofType: "plist")
    //ahora recuperamos los datos de ese archivo
    let datos = FileManager.default.contents(atPath: rutaLectura!)
    //estos datos hay que pasarlos a algo con lo que poder trabajar, son datos en bruto
    let datosSwift = try PropertyListSerialization.propertyList(from: datos!, options: [], format: nil) as! [String:Any]
    let arrayPokemons = datosSwift["pokemons"] as! [String]
} catch {
    print(error.localizedDescription)
}


// Crear una función throw, convertir una función falible a una con errores
// Ejemplo con una función que ya usamos, y que puede devolver nil por varias causas pero no sabremos lo que pasó: si no existe el rango, o si cadena o sub son vacíos
// Para que devuelva un error y poder gestionarlo añadimos la palabra throws antes del parámetro de salida, hacemos que no devuelva un opcional y cambiamos el código de rotura del guard (función original comentada)
//func posicionEn(cadena: String, sub: String) -> Int? {
//    guard let rango = cadena.range(of: sub), !sub.isEmpty, !cadena.isEmpty else { return nil }
//    return cadena.distance(from: cadena.startIndex, to: rango.lowerBound)
//}
// Además el ejemplo se completa creando nuestros propios errores en un enum

enum errores: Error {
    case subcadenaNoEncontrada, cadenaVacia, subcadenaVacia
}

func posicionEn(cadena: String, sub: String) throws -> Int {
//    guard let rango = cadena.range(of: sub), !sub.isEmpty, !cadena.isEmpty else {
//        throw NSError(domain: "ERROR", code: 0, userInfo: nil)
//    }
    if cadena.isEmpty {
        throw errores.cadenaVacia
    }
    if sub.isEmpty {
        throw errores.subcadenaVacia
    }
    guard let rango = cadena.range(of: sub) else {
        throw errores.subcadenaNoEncontrada
    }
    
    return cadena.distance(from: cadena.startIndex, to: rango.lowerBound)
}
let cadena1 = "One ring to rule them all"
let cadena2 = ""
do {
    try posicionEn(cadena: cadena1, sub: "ring") //devuelve 4
    try posicionEn(cadena: cadena1, sub: "anillo") //error y va por el catch
} catch errores.subcadenaNoEncontrada {
    print("Subcadena no encontrada")
} catch errores.cadenaVacia {
    print("La cadena está vacía")
} catch errores.subcadenaVacia {
    print("La subcadena está vacía")
}
// Y como punto final, todo esto se puede poner dentro de una extensión para String
