import Foundation

// ARRAYS
// Son colecciones ordenadas de elementos del mismo tipo, a los que se le asigna un número entero para su posición
// Puede tener elementos repetidos, pero cada uno tiene su posición fija, a la que se puede acceder por su índice
// Los arrays siempre empiezan en 0, y no puede haber huecos vacíos en medio
// Se almacenan en una variable o constante y funciona de la misma forma la inferencia de tipo o la tipificación:
var matrizNúmero = [1,2,3,4]
let matrizTipificada: [String] = ["cinco", "seis","siete"]
matrizNúmero[0] //así se accede a un valor, con su índice

// Los arrays no tienen control de errores; esto es, podemos tener un error fatal si intentamos acceder a un valor que no existe
// Algunas propiedades interesantes:
matrizNúmero.count
matrizNúmero.capacity //capacidad del array: cuántos elementos caben, y se puede fijar a la hora de declararlo si sabemos de antemano el número de elementos que contendrá
matrizNúmero.first
matrizNúmero.last
matrizNúmero.isEmpty

// Se pueden crear o declarar arrays vacíos:
var arrayVacío = [String]()
var arrayVacíoSistema = Array<String>()
var vacíoTipificado: [String] = []
arrayVacío.reserveCapacity(20) //así se reserva la capacidad: es un array con 0 elementos pero con una capacidad de 20 elementos. Si lo hacemos así el sistema será más rápido

// Los arrays son tipos de datos por valor, esto es, son mutables o inmutables en función de cómo se declaren (let o var), no son objetos o tipos por referencia
// Además, al hacer una copia de un array se copia valor por valor, no se copia la referencia


// AÑADIR ELEMENTOS
// Añadir un valor (al final):
arrayVacío.append("John Williams")
// Añadir varios (al final):
arrayVacío += ["Danny Elfman", "James Howard", "Brian Tyler"]

// Cambiar el valor de una posición ya creada, o varios con un rango:
arrayVacío[3] = "Alan Silvestri"
arrayVacío[1...3] = ["Hans Zimmer", "David Arnold", "Patrick Doyle"]
//si en la línea anterior le damos 3 posiciones pero solo dos valores, sustituye los dos valores aportados y borra la tercera posición
//al contratio, si damos 3 posiciones pero 4 valores, pues añade ese valor de más a continuación de los otros

// Podemos insertar datos en un punto determinado:
arrayVacío.insert("Howard Shore", at: 4)
arrayVacío.insert(contentsOf: ["Harry Gregson","James Horner"], at: 3)
var compositores = arrayVacío //esto es para usarlo más adelante


// QUITAR ELEMENTOS
// Quitar el primero o los n primeros:
arrayVacío.dropFirst()
//OJO: este método devuelve una COPIA del array sin el primer elemento, pero NO BORRA el elemento, el array en cuestión sigue igual
arrayVacío.dropFirst(3)
arrayVacío.dropLast()
arrayVacío.dropLast(3)

// Borrado
arrayVacío.removeLast() //devuelve el elemento en cuestión y SÍ lo elimina del array
arrayVacío.removeFirst()
arrayVacío.removeFirst(2) //en este caso devuelve el array ya modificado
arrayVacío.remove(at: 2)
//arrayVacío.removeSubrange(2...4) //comentada para evitar el error
arrayVacío.removeAll(keepingCapacity: true) //borra todos los datos pero mantiene la capacidad que tenía


// BUSCAR Y ENUMERAR
// Extraer datos con un rango:
compositores[..<4] //valores de posición 0 a 3
compositores[4...] //valores de posición 4 al final

// Buscar elementos:
compositores.firstIndex(of: "Hans Zimmer") //devuelve el índice de la primera coincidencia
compositores.lastIndex(of: "Hans Zimmer")

// Enumerar valores, recorrer el array:
for compositor in compositores {
    print(compositor)
}
for (indice,compositor) in compositores.enumerated() {
    print("\(indice): \(compositor)")
}
// Otro ejemplo con números para extraer los pares
let numeros = [1,6,4,7,8,5,7,3,8,6]
for valor in numeros {
    if valor % 2 == 0 {
        print(valor)
        // recorre el bucle 10 veces pero solo da 5 resultados; se puede optimizar con where
    }
}
for valor in numeros where valor % 2 == 0 {
    print(valor)
}
for compositor in compositores where compositor.hasPrefix("H") {
    print(compositor)
}


// ORDENAR ELEMENTOS
compositores.sorted() //ordena una copia y no modifica el original, devuelve la copia
compositores.sort() //ordena el array en cuestión y modifica el array original, no devuelve nada

// Interfaces fluidas o llamadas consecutivas de métodos (tantas como necesitemos)
for (indice, compositor) in compositores.sorted().reversed().enumerated() {
    print("\(indice): \(compositor)")
}


// ARRAYS DE 2 Y 3 DIMENSIONES: arrays dentro de arrays
var multiArray2D = [[String]]()
var multiArray3D = [[[Int]]]()
multiArray2D = [["uno","dos","tres"],["cuatro","cinco","seis"]]
multiArray2D[1] //accede al array de la posición 1
multiArray2D[1][1] // accede al elemento de la posición 1 del array en la posición 1

multiArray3D = [[[2,3,4],[5,6]],[[5,4],[8,6,7]]] //un array con dos elementos arrays, con 2 arrays cada uno
// para acceder el número 8:
multiArray3D[1][1][0]

// Para enumerar todos los valores hay que iterar cada dimensión:
for valor in multiArray2D { //valor es [String]
    for valor2 in valor { //valor2 es String
        print(valor2)
    }
}


// OTRAS FUNCIONALIDADES
var numeros2 = [1,2,3,5,7,8,9,10,13,14,16,18]

// Crear array con elementos repetidos o con rango
var relleno = [Int](repeating: 0, count: 50)
var relleno2 = [Int](1...20)

// Desordenar valores aleatoriamente
numeros2.shuffled() //crea copia desordenada
numeros2.shuffle() //desordena el propio array

// Más cosas
numeros2.randomElement()
numeros2.max()
numeros2.min()
numeros2.starts(with: 1...5)
numeros2.swapAt(10, 5) //intercambia valores
