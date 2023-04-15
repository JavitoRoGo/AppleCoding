import Foundation
import UIKit

// Conversión de tipos, o subir y bajar en la jerarquía de datos: upcasting y downcasting con as
// UPCASTING. Se pasa de un tipo de dato a Any, y se perdería esa información del tipo de dato (con downcasting se recupera)
let matrizMixta:[Any] = ["Uno", 2, "Tres", 4.0, true] //es un array de tipo Any, por lo que se cumple que es de un solo tipo de dato
let valor = matrizMixta[2] //devuelve "Tres", pero es de tipo Any, por lo que no podemos acceder a sus métodos
// También se puede:
let valorAny = "Tres" as Any

// DOWNCASTING. Así recuperamos el tipo original, string en este ejemplo
let valor2 = matrizMixta[2] as? String //valor2 es de tipo String?, y devolvería nil si no es posible
// Al ser opcional mejor hacer el downcasting con if let

// En el caso de las clases, el equivalente al tipo superior Any sería UIView:
let boton = UIButton(type: .system)
let boton1 = UIButton(type: .infoDark)
let boton2 = UIButton(type: .contactAdd)
let etiqueta = UILabel()
let campo = UITextField()
let interfaz = ["boton1": boton, "etiqueta": etiqueta, "campo": campo, "boton2": boton1, "boton3": boton2]
// Lo anterior es un array de tipo [UIView]
if let otro = interfaz["boton2"] as? UIButton {
    //recupera el valor del diccionario con la clave indicada y lo pasa o baja al tipo UIButton
    otro.setTitle("algo", for: .normal)
}
// Un ejemplo para rescatar los datos del array que sean de tipo boton:
for (clave, dato) in interfaz {
    if let botonRecuperado = dato as? UIButton {
        botonRecuperado.setTitle("eso", for: .normal)
    }
}
// Otra forma de hacer lo mismo pero más eficiente es:
for (_, dato) in interfaz where dato is UIButton {
    let botonRecuperado = dato as! UIButton
    botonRecuperado.setTitle("otro", for: .normal)
}
