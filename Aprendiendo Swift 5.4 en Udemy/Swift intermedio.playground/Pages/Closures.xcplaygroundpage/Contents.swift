import Foundation

// CLOSURES
// Es una función anónima sin nombre para los parámetros. La estructura básica es:
_ = { () -> () in } //como no tiene entidad hay que igualarlo a algo, guardarlo en algo, valor vacío en este ejemplo
// Ejemplo de pasar una función a closure: basta con quitar func y el nombre y poner llave de inicio (e igualar a algo)
func sumar3(numero: Int) -> Int {
    return numero + 3
}
var suma3 = { (numero: Int) -> Int in
    return numero + 3
}
sumar3(numero: 2) //función
suma3(2) //closure, sin nombre del parámetro


// Closures como parámetros de funciones
// Ejemplo de función que recibe un parámetro Int y un parámetro closure, que a su vez recibe Int y devuelve Int; y a su vez la función devuelve otro Int
func sumatorio(valor: Int, sumaFunc: (Int) -> Int) -> Int {
    return sumaFunc(valor)
}
let closure = { (valorNumero: Int) -> Int in
    return valorNumero + 5
}
sumatorio(valor: 4, sumaFunc: closure)
//también podríamos poner el closure directamente
sumatorio(valor: 4, sumaFunc: { (valorNumero: Int) -> Int in return valorNumero + 5 })


// Reducción de closures: eliminación de código por inferencia para simplificar
sumatorio(valor: 4, sumaFunc: { $0 + 5 })
/*Lo que se ha eliminado es:
 - Se puede quitar el tipo del parámetro porque ya se especifica al definir la función sumatorio y su parámetro de closure
 - Al no tener que poner el tipo de dato, podemos quitar también los paréntesis
 - Se puede quitar el tipo de salida, por lo mismo, lo especifica en el parámetro de la función
 - Se puede quitar el nombre del parámetro: los closures no tienen nombre de parámetro, se los ponemos por comodidad para trabajar con ellos, pero aquí hay uno solo y por tanto se puede quitar
 - Y también la palabra clave in, puesto que ya solo quedaría el propio cuerpo del closure
 - Al quitar el nombre del parámetro, usamos su notación abreviada o su nombre anónimo, que es $ y el índice que ocupa si hubiera varios
 - Y como lo único que queda es la propia acción del closure, también se quita el return
 */
sumatorio(valor: 4) { $0 + 5 }
// Y por último, lo que se ha hecho es cerrar la función después del primer parámetro y a continuación indicar el closure: le estamos indicando que inyecte el closure indicado dentro de la función
// Esto puede hacerse siempre que el último parámetro de una función sea un closure: se cierra con ) y luego se indica el closure
let closure1 = { $0 + 5 }

// Otros ejemplos de uso
// Repetir un número de veces el closure que indiquemos
func repetir(veces: Int, tarea: () -> ()) {
    for _ in 0..<veces {
        tarea()
    }
}
repetir(veces: 7) { print("Repite") }

func unaTarea() {
    print("Haz algo")
}
repetir(veces: 8, tarea: unaTarea)
