import Foundation

// DICTIONARIES

// Colección de datos no ordenada, entre corchetes, y se caracterizan por tener pares de índice o clave y valor: key-value. Al ser no ordenada, accedemos a cada valor por su clave, que la difinimos nosotros
// Un diccionario siempre devuelve un opcional para protegernos de la posibilidad de que no exista la clave que estamos buscando
// Son tipos por valor, se copian tal cual y no como objetos o referencias

var diccionario1:[Int:String] = [:] //inicialización en vacío
diccionario1 = [1:"Uno", 2:"Dos", 3:"Tres"]
var diccionario2: [Int:Int] = [1:5, 2:3]
var diccionario3 = [5:"Cinco", 6:"Seis", 7:"Siete"] //declaración por inferencia
var diccionario4 = Dictionary<String, Int>() //declaración primitiva a partir de genéricos

// Acceder a los datos

diccionario2[2] //devuelve el elemento de clave 2, que es el valor 3
let valor = diccionario3[7] //esta let es de tipo String? y habría que desempaquetarlo para usarlo:
if let valor1 = diccionario3[7] {
    print(valor1)
}
//una alternativa es usar el operador de coalescencia o proporcionar un valor por defecto: las dos líneas siguientes hacen exactamente lo mismo (los valores obtenidos ya no son opcionales):
let valor2 = diccionario3[7] ?? "algo"
let valor3 = diccionario3[7, default: "algo"]

// Añadir o modificar elementos
var diccionario: [String:String] = [:]
diccionario["nombre"] = "Julio" //añade un valor
diccionario["nombre"] = "César" //modifica el valor de la clave dada

// Método update para modificar valores
diccionario.updateValue("Julio César", forKey: "nombre") //si la clave existe devuelve el valor anterior
diccionario.updateValue("Fernández", forKey: "apellido") //no existe la clave, por lo que devuelve nil pero sí añade el valor

// Eliminar un valor
diccionario["apellido"] = nil //borra el valor de esa clave. O también como sigue:
diccionario.removeValue(forKey: "nombre") //si encuentra la clave devuelve un valor

// Iterar: devuelve dos valores, por lo que necesita dos constantes para iterar. Algunos ejemplos:
for (key,value) in diccionario3 {
    print("La clave es \(key) y el valor es \(value)")
}
for (key,value) in diccionario3 where key < 7 { //también funciona el where
    print("La clave es \(key) y el valor es \(value)")
}
for valor in diccionario3.keys { //itera solo en las keys
    print(valor)
}
// Podemos coger los valores o claves y crear directamente un array, y hasta ordenarlo a la vez:
let arrayValues = [String](diccionario3.values.sorted())


// Array de diccionarios. Se usan mucho en json
let dic1:[String:String] = ["Film":"Interstellar", "Director":"Chris Nolan", "Música":"Hans Zimmer"]
let dic2:[String:String] = ["Film":"Jurassic World", "Director":"Colin Trevorrow", "Música":"Michael Giacchino"]
var arrayDiccionario = [[String:String]]()
//esto sirve para unir varios diccionarios que tienen las mismas claves
arrayDiccionario.append(dic1)
arrayDiccionario.append(dic2)

// Para acceder a un valor (recordar que en los diccionarios son opcionales):
if let film = arrayDiccionario[1]["Film"] {
    print(film)
    //accede al elemento (diccionario) de la posición 1, y a su elemento de clave Film
}
//OJO: para crear el array las claves no tienen que ser iguales
let dic3:[String:String] = ["Compositor": "Michael Giaccino", "Oscars":"1"]
arrayDiccionario.append(dic3)
