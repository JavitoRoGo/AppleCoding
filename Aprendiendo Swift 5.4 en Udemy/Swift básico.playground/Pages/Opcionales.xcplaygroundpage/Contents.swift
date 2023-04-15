import Foundation

// OPCIONALES
// Representan la posibilidad de no tener valor, de ser un valor vacío o nulo. Un valor vacío hay que desempaquetarlo antes de poderlo usar como un valor normal
var cadena: String?
cadena = "Hola"
print(cadena)
print(cadena!)



// ENLACES OPCIONALES
// Permite ver lo que hay dentro de un opcional con la seguridad que no dará error si no hay nada: if let
var opcional: String?
if let constante = opcional {
    // comprueba si la var opcional contiene un valor, y si lo tiene, lo asigna a constante
    print(constante)
} else {
    print("El opcional no contiene valor")
}
// Para desempaquetar varios a la vez se hace separándolos por comas. Pero OJO, se comporta como si tuviéramos AND: solo desempaqueta todos los valores si todos son no nulos
var ab: String? = "10"
var ac: String? = "20"
var ad: Int? = 30
if let ab = ab, let ac = ac, let ad = ad {
    print(ab, ac, ad)
}
// Podemos incluso añadir una condición que evalúe un valor después de desempaquetarlo:
if let ab = ab, let ac = ac, let ad = ad, ad != 0 {
    print(ab, ac, ad)
}
// Con if-let el valor desempaquetado SOLO está disponible dentro del ámbito del if. Para usarlo fuera del if se usa guard

// GUARD LET
var abc: String?
abc = "valor opcional"
guard let vab = abc else {
    throw NSError(domain: "Opcional vacía", code: 0, userInfo: nil)
    //ponemos este error porque en un playground no deja usar return o break
}
// else entra en acción si no se cumple el desempaquetado, o sea, que el valor sea nil
print(vab) //así el valor desempaquetado es accesible fuera del ámbito

// Operador de coalescencia nula
// Permite evaluar un opcional y devolver un valor adicional cuando el resultado es nil
var a: Int?
let b = 10
let c = a ?? b
print(c) //además este operador devuelve el valor ya desempaquetado
// El operador ?? hace básicamente lo siguiente (operador ternario):
a != nil ? a! : b
