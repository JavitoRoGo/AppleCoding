import Foundation

// SETS O CONJUNTOS

// Colección de elementos no ordenada y no indexada, por lo que no podemos acceder a sus elementos; solo podemos saber si un elemento está o no en el conjunto. Además, los datos no se pueden repetir
// Representa a los conjuntos matemáticos

var conjunto1 = Set<String>() //set vacío
var conjunto2: Set = ["John Williams", "James Horner", "Jerry Goldsmith"] //set con datos

// Acciones con sets
conjunto2.count
conjunto2.contains("John Williams")
conjunto2.first //accede al primer valor, pero no se puede acceder a ningún otro valor
conjunto2.insert("Michael Kamen")
conjunto2.insert("James Horner") //si el valor ya existe no lo añade y devuelve un false, y se puede acceder a ese valor:
conjunto2.insert("James Horner").inserted
conjunto2.remove("valor") //borra el valor que indicamos, y devuelve nil en caso de que no exista: si existe devuelve ese mismo valor y lo borra
//iterar
for valor in conjunto2.sorted() {
    print(valor)
    //así salen ordenados porque si no saldrían como le diera
}

// Algebra de conuntos
// La suma o unión de conjuntos no se hace con suma porque los datos repetidos darían problemas; se hace con set1.union(set2), y así obtenemos un nuevo set con la unión (sin repetir) de los otros dos
// Si hacemos set1.formUnion(set2) se modifica el propio set1 añadiendo los elementos del set2:
var set3 = conjunto2.union(conjunto1)
conjunto2.formUnion(conjunto1)
// La resta es similar: se puede crear una copia con el resultado (.subtracting) o restar y modificar el propio set (.subtract):
var set4 = conjunto2.subtracting(conjunto1)
conjunto2.subtract(conjunto1)
// Igual con la intersección de conjuntos: .intersection y .formIntersection:
var set5 = conjunto2.intersection(conjunto1)
conjunto2.formIntersection(conjunto1)
// La diferencia simétrica devuelve los elementos no comunes de ambos conjuntos: quita en uno los elementos que ya están en el otro:
var set6 = conjunto2.symmetricDifference(conjunto1)
conjunto2.formSymmetricDifference(conjunto1)

// Comparación de conjuntos. Al comparar conjuntos se devuelve siempre un bool
// Subconjunto: set1 es subconjunto de set2 si todos los elementos de set1 están en set2:
conjunto1.isSubset(of: conjunto2)
// Superconjunto: es lo contrario, set2 es superconjunto si contiene a set1
conjunto2.isSuperset(of: conjunto1)
// Comparación
conjunto1 == conjunto2
// Disjunto: no tienen elementos comunes entre los dos conjuntos
conjunto2.isDisjoint(with: conjunto1)
