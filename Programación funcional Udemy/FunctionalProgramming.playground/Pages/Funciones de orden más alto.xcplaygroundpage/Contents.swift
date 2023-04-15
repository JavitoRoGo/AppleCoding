//: [Previous](@previous)

import UIKit

// FUNCIONES DE ORDEN MÁS ALTO

// MARK: - MAP

// Permite transformar cada elemento de una colección según un algoritmo que le pasamos: aplica el closure que le pasemos a cada elemento

let array = [1, 4, 5, 7, 8, 7, 6, 4, 5, 4, 5, 4, 3, 2, 4, 5, 6, 7]
let arrayPics = ["Alias", "Alien", "BasicInstinct", "Alines", "AmazingStories", "BoysFromBrazil", "AmericanTail"]

let newArray = array.map { $0 } // devuelve el mismo
let newArrayD = array.map { Double($0) } // transforma a Double
// se puede hacer cualquier transformación
let newArrayS = array.map { "\($0)€"}

let arrayPictures = arrayPics.map { UIImage(named: "\($0).jpg") }
// Si no queda bien claro el tipo que tiene que devolver la función map, entonces hay que indicarlo explícitamente. Esto ocurre siempre que hay más de una salida:
let arrayPictures1 = arrayPics.map { name -> UIImage? in
    if let imagen = UIImage(named: "\(name).jpg") {
        return imagen
    } else {
        return nil
    }
}



// MARK: - FILTER

// Función para filtrar una colección en base al algoritmo que le digamos

let arrayFiltrado = array.filter { $0 <= 5 }
arrayFiltrado
// Otro ejemplo para ver cómo nos permite filtrar por cualquier propiedad según sea el tipo de la colección:
let arrayPic100 = arrayPictures.filter { $0?.size.width == 100 }



// MARK: - REDUCE

// Reducir todos los elementos a solo uno mediante algoritmo de agregación desde un resultado de inicio

let reduce1 = array.reduce(0) { $0 + $1 } //se le da un valor inicial y luego el closure de transformación, sumatorio en este caso empezando en 0
// Como los comandos de operaciones matemáticas son funciones, lo anteior puede ponerse también así:
let reduce2 = array.reduce(0, +)
let reduce3 = array.reduce(1, *)

// O sea, reduce la colección a un solo resultado aplicando el algoritmo que le digamos, con valor de inicio y closure para la acumulación

// También podemos transformar:
let comma = array.reduce("") { "\($0),\($1)" }
comma.dropFirst() // para quitar la coma inicial


// Otra versión del reduce, que trabaja con una variable inout con estado que es "acumulado"
let comma2 = array.reduce(into: "") { acumulado, valor in
    acumulado += "\(valor),"
}
comma2.dropLast() //para quitar la coma del final



// MARK: - ALLSATISFY

// ¿Cumplen todos los elementos con una condición?

let result1 = array.allSatisfy { $0 < 10 }
result1



// MARK: - COMPACTMAP

// Como la función map pero para trabajar con opcionales: si el resultado no es nil entonces lo incluye ya enlazados o desempaquetados
// El ejemplo que vimos para las imágenes con la función map devuelve opcionales:
// let arrayPictures = arrayPics.map { UIImage(named: "\($0).jpg") }, si una imagen no existe pues tendríamos un nil
// Esto se evita con compactMap
let imagesNotNil = arrayPics.compactMap { name in
    UIImage(named: "\(name).jpg")
}
// Hace dos cosas: comprueba que no haya nulos (los elimina) y los otros datos los desempaqueta. Por eso el closure que pongamos tiene que devolver opcionales



// MARK: - CONTAINS

// Comprueba si un elemento contiene un determinado valor o condición que indiquemos

let result = array.contains(4)
let result2 = array.contains { num in
    num > 7
}



// MARK: - DROP Y PREFIX

// Nos permiten segmentar el elemento o colección según se cumpla una condición

// drop descarta aquellos elementos que cumplan la condición; desde que no se cumpla, devuelve el resto aunque no cumpla
let resultDrop = array.drop { $0 < 8 }
resultDrop

// prefix es complementaria y hace lo contrario: devuelve los elementos que cumplen y para cuando ya no se cumple
let resultPrefix = array.prefix { $0 < 8 }
resultPrefix



// MARK: - FIRST, LAST

// Recuperar el primer o último elemento de una colección que cumpla con una condición. Devuelven opcionales

let resultFirst = array.first { $0 > 3 }
resultFirst
let resultLast = array.last { $0 > 3 }
resultLast



// MARK: - FIRSTINDEX Y LASTINDEX

// Devuelve un opcional con el índice del elemento que cumple la condición

let resultFirstIndex = array.firstIndex { num in
    num > 3
}
let resultLastIndex = array.lastIndex { num in
    num > 3
}



// MARK: - FLATMAP

// Aplana una colección de más de una dimensión a un resultado de dimensión única, transformándolo también si se necesita

let array2 = [[1,4,5,7], [8,7,6,4,5], [4,5,4], [3,2,4,5,6,7]] // matriz o arrays dentro de array
let newArray2 = array2.map { "\($0)€" }
newArray2 // sale raro el resultado, y para eso está flatMap, que aplana el array o lo pasa a una sola dimensión

let arrayFlat = array2.flatMap { $0 }
arrayFlat // lo devuelve aplanado o en una sola dimensión
let arrayFlat1 = array2.flatMap { $0.map { $0 + 1 }}
arrayFlat1 // en este caso lo aplana y luego los transforma
let arrayFlat2 = array2.flatMap { arrayInts in
    arrayInts.map { num in
        "\(num)€"
    }
}
arrayFlat2 // así se entiende mejor



// MARK: - FOREACH

// Recorre una colección y realiza una misma operación suministrada para cada elemento. Es lo mismo que un for-in

for num in array {
    print(num)
}
array.forEach { num in
    print(num)
}
// Lo anterior es lo mismo; la diferencia principal está en que el foreach se realiza a un nivel más bajo en C y no en Swift, así que gasta menos memoria y es más rápido que un for-in
// Un inconveniente es que foreach no nos permite hacer .enumerated y obtener también el índice de la iteración, y for-in sí
// En el siguiente ejemplo para obtener los números pares, el foreach sería lo más rápido y óptimo:
for num in array where num % 2 == 0 {
    print(num)
}
array.forEach { num in
    if num % 2 == 0 {
        print(num)
    }
}



// MARK: - SORTED

// Es para ordenar colecciones, y tiene 4 versiones que ordenan pero con aspectos diferentes:
/*
 1. sort() función que no devuelve nada; modifica la colección y la ordena en orden ascendente. Solo puede aplicarse a parámetros con estado (variables)
 2. sorted() función que devuelve una colección del mismo tipo pero ordenada de forma ascendente. No modifica la colección original sobre la que se aplica, no modifica el estado de aquello que es su parámetro
 Hasta aquí son funciones simples, y las siguientes son funciones de orden más alto
 3. sort(by:) no modifica el estado, no devuelve nada (igual que 1), pero permite recibir una función como parámetro para aplicar criterios de ordenación
 4. sorted(by:) modifica el estado y devuelve una nueva colección ordenada según el predicado que le indiquemos como closure. Recibe dos elementos de la colección como parámetros para compararlos y establecer la ordenación, y devuelve el primer valor y su siguiente.
    Emplea el método de ordenación de la burbuja, de tal forma que coge un valor y su siguiente, y si la comparación devuelve true pues los deja tal cual; y si la comparación devuelve false, los invierte. Y esto lo hace recorriendo toda la colección y comparando pares de valores. Y recorre el array todas las veces que haga falta hasta que todas las comparaciones dan true
 */

let sorted1 = array.sorted {
    $0 > $1
}
sorted1
// lo anterior es lo mismo que lo siguiente:
let sorted2 = array.sorted().reversed()
// la ventaja en hacerlo de la primera forma es que podríamos comparar diferentes propiedades que pueda tener $0 (si el array fuera de datos complejos como struct y no datos simples)



// MARK: - REMOVEALL

// Borrado de todos los elementos, de todos tal cual o cumpliendo alguna condición que le pasemos en closure. Esta función tiene estado porque se aplica directamente sobre el elemento

var arrayToRemove = array
arrayToRemove.removeAll { $0 % 2 == 0 } // borra los pares
arrayToRemove.removeAll() // tiene estado, afecta al elemento, así que tiene que ser var



// MARK: - INTERFACES FLUIDAS

// Se trata de conectar los resultados de una función de orden más alto a otra. Es la capacidad de copiar objetos o tipos, de autodeclarar nuevos objetos en base a su tipo (o algo así)

let array3 = array.map { "\($0)" }
// lo anterior se autodeclara directamente como un array de strings, por lo que podemos aplicar sobre él cualquier función de orden más alto de las vistas: remove, reduce, sort, etc.
// En el ejemplo siguiente vamos a obtener un array con los valores menores o iguales a 5, y vamos a concatenar diferentes funciones de orden más alto. OJO a la forma de redactarlo en varias líneas para que se vea más claro:
// Es la forma de hacerlo o la forma en que trabaja SwiftUI, Combine y cualquier otra interfaz declarativa: cada línea se aplica al resultado de lo anterior
let arrayA = array
    .filter { $0 <= 5 } // menores o iguales a 5
    .sorted { $0 < $1 } // ordena de menor a mayor
    .map { "\($0)€" } // transforma a [String]
    .reduce("") { "\($0),\($1)" } // transforma a String, una única cadena
    .dropFirst() // elimina la primera coma
arrayA



//: [Next](@next)
