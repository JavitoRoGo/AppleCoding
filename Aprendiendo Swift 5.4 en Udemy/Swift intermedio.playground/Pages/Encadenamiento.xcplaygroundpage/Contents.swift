import Foundation
import Darwin

// ENCADENAMIENTO DE OPCIONALES
// Pasar a través de una instancia o propiedad opcional con ? porque no sabemos si será nil, en cuyo caso se para
class Compositor {
    var name: String
    var filmografia: Filmografia?
    
    init(name: String) {
        self.name = name
    }
}
class Película {
    var nombre: String
    var año: Int?
    var cd: CD?
    
    init(nombre: String) {
        self.nombre = nombre
    }
}
class CD {
    var duracion: Double?
    var npistas: Int?
}
class Filmografia {
    var peliculas = [Película]()
    var fichaIMDB: URL?
}

let mg = Compositor(name: "Michael Giacchino")

let tomorrowland = Película(nombre: "Tomorrowland")
let jurassicworld = Película(nombre: "Jurassic World")
let insideout = Película(nombre: "Inside Out")
let jupiterascending = Película(nombre: "Jupiter Ascending")

let giacchino_films = Filmografia()
giacchino_films.peliculas = [tomorrowland,jurassicworld,insideout]
giacchino_films.peliculas[2] = jupiterascending

let twCD = CD()
twCD.duracion = 73.24
twCD.npistas = 24

tomorrowland.cd = twCD
mg.filmografia = giacchino_films

func buscarPelicula(pelis: [Película], titulo: String) -> Int? {
    for (indice, film) in pelis.enumerated() {
        if film.nombre == titulo {
            return indice
            //devuelve el indice de una peli dentro del array de Película cuyo título sea el indicado
        }
    }
    return nil
}
// Veamos cómo obtener la duración de un disco concreto:
if let filmografia = mg.filmografia {
    //primero buscamos si existe la filmografia, que es opcional
    if let indice = buscarPelicula(pelis: filmografia.peliculas, titulo: "Tomorrowland") {
        //luego buscamos la peli en concreto y su índice, opcional
        if let cd = filmografia.peliculas[indice].cd {
            //ahora se busca el cd para esa película, también opcional
            if let duracion = cd.duracion {
                print("La banda sonora de \(filmografia.peliculas[indice].nombre) tiene una duración de \(duracion)")
            }
        }
    }
}
// Como hay tantos opcionales nos queda la pirámide del mal con 4 if-let encadenados. Esto se soluciona con el encadenamiento de opcionales
if let peliculas = mg.filmografia?.peliculas {
    if let indice = buscarPelicula(pelis: peliculas, titulo: "Tomorrowland") {
        if let duracion = mg.filmografia?.peliculas[indice].cd?.duracion {
            print("La banda sonora de \(peliculas[indice].nombre) tiene una duración de \(duracion)")
        }
    }
}
