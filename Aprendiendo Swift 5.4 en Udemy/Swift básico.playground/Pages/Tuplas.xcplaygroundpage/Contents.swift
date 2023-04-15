import Foundation

// TUPLES, otro tipo de colección
// Es un registro o conjunto de datos que va entre paréntesis y se puede guardar en una constante o variable. Permite varios tipos de datos:
let pelicula = ("Tomorrowland", 2015, 8.4)
pelicula.0
pelicula.1
// Cada valor tiene un índice asignado como si fuera un array. Y podemos poner nuestras propias etiquetas:
let pelicula1 = (titulo: "Tomorrowland", año: 2015, rank: 8.4)
pelicula1.rank
// También se puede definir la etiqueta en la propia declaración:
let pelicula2:(titulo:String, año:Int, rank:Double) = ("Tomorrowland", 2015, 8.4)
let pelicula3:(String,Int) = ("Jurassic World", 2015)

// Descomponer una tupla:
let (film, year, rank) = pelicula //así creamos de golpe 3 constantes cada una con su valor correspondiente de la tupla
let nombre = pelicula.0
let (nombre2, _, _) = pelicula //así coge solo el título

// Array de tuplas, directamente o con etiquetas, igual que una tupla simple
let pelis = [("Tomorrowland", 2015, 9), ("Inside out", 2015, 10), ("Interstellar", 2014, 10), ("Groundhog Day", 1993, 8), ("The Goonies", 1985, 9), ("The dark knight", 2008, 9), ("Artificial intelligence", 2001, 10), ("Jurassic Park", 1993, 8)]
let pelis2: [(pelicula:String, año:Int, rank:Int)] = [("Tomorrowland", 2015, 9), ("Inside out", 2015, 10), ("Interstellar", 2014, 10), ("Groundhog Day", 1993, 8), ("The Goonies", 1985, 9), ("The dark knight", 2008, 9), ("Artificial intelligence", 2001, 10), ("Jurassic Park", 1993, 8)]
// Iteración:
for film in pelis2 where film.rank > 9 {
    print("La película \(film.pelicula) se estrenó el año \(film.año) y tiene una puntuación de \(film.rank)")
}
// También podemos usar switch:
for film in pelis2 {
    var mensaje: String
    switch film {
    case (_, 2015, _): mensaje = "La película \(film.pelicula) es de 2015"
        //el case anterior entra o se activa cuando el año sea 2015
    case let (_, year, _) where year < 2000: mensaje = "La película \(film.pelicula) es anterior al año 2000"
        //el case anterior captura con let el año (year) y luego lo compara con where para que solo entre cuando el año sea menor a 2000
        //este ejemplo de captura da muchas posibilidades para jugar con un switch
    default: mensaje = ""
    }
    if !mensaje.isEmpty {
        print(mensaje)
        //hacemos esto para que solo imprima cuando mensaje tiene un valor
    }
}

// La siguiente declaración de 4 variables se puede simplificar si lo hacemos con una tupla y la descomponemos
//let var1 = "Hola"
//let var2 = "K ases"
//let var3 = "Programas"
//let var4 = "O k ases"
let valores = ("Hola", "K ases", "Programas", "O k ases") //tupla con los valores
let (var1, var2, var3, var4) = valores //descomposición

// Cómo intercambiar valores con una tupla, muy fácil
var x = 320
var y = 200
//lo normal sería con una variable temporal:
//var temp = x
//x = y
//y = temp
//con tupla sería:
(x, y) = (y, x)
