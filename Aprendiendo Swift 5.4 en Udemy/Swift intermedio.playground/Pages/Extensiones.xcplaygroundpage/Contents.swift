import Foundation

// EXTENSIONES
// Nos permiten ampliar la funcionalidad de un tipo de dato, clase o struct, añadiendo nuestro propio código: métodos y propiedades calculadas
// No necesitamos acceder al código fuente que queremos modificar, pues lo que hacemos es añadir un comportamiento
// Veamos un ejemplo con una función falible que nos devuelve la posición de una subcadena dentro de una cadena:
func posicionEn(cadena: String, sub: String) -> Int? {
    guard let rango = cadena.range(of: sub), !sub.isEmpty else { return nil }
    //si sub no está dentro de cadena, o sub es vacío entonces devuelve nil. Si no:
    return cadena.distance(from: cadena.startIndex, to: rango.lowerBound)
}

let cadena = "A long time ago, in a galaxy far far away"
posicionEn(cadena: cadena, sub: "galaxy")
// Esta función sería muy práctica tenerla como parte de los métodos del tipo String; y para eso precisamente son las extensiones
// Incluimos la función anterior dentro de la extensión y la retocamos para no tener que incluir la propia cadena como parámetro, que sería self porque ya estamos dentro de la cadena
extension String {
    func posicionEn(sub: String) -> Int? {
        guard let rango = self.range(of: sub), !sub.isEmpty else { return nil }
        return self.distance(from: self.startIndex, to: rango.lowerBound)
    }
    //añadimos además una propiedad
    var espacios: Int {
        get { self.components(separatedBy: " ").count - 1 }
        //devuelve un array con los componentes separados por lo que le indiquemos, espacio en este caso
        //separados por espacio lo que nos devuelve son las palabras, por eso restamos 1 para tener el número de espacios
    }
}
cadena.posicionEn(sub: "galaxy")
cadena.espacios

//Otro ejemplo
class miClase {
    //lo que sea
}
protocol miProtocolo {
    //lo que sea
}

extension miClase: miProtocolo {}
//así conseguimos que, a partir de esta línea, la clase se conforme al protocolo, aunque al definir la clase no lo hayamos indicado


// EXTENSIONES DE PROTOCOLOS, que funcionan diferente a los visto hasta ahora para las extensiones
import GameplayKit //hace falta para el ejemplo
// Ejemplo de creación de personajes, y con el protocolo vamos a crear una característica que sea que puedan atacar
protocol Luchador {
    //pondremos las características que tenga que tener aquel personaje que creemos que sea luchador (los protocolos definen lo que sí o sí debe contener algo)
    func lanzarAtaque() -> Int
    var ataque: Int { get set }
}

class Personaje {
    var vida: Int
    var fuerza: Int
    var muerto = false
    
    func pierdeVida(cantidad: Int) {
        vida -= cantidad
        if vida <= 0 {
            haMuerto()
        }
    }
    func haMuerto() {
        muerto = true
    }
    
    init(vida: Int, fuerza: Int) {
        self.vida = vida
        self.fuerza = fuerza
    }
}
class Heroe: Personaje, Luchador {
    enum Poderes {
        case espada, magia, saltar
    }
    var poder: Poderes
    
    var ataque: Int {
        get { return fuerza * 2 }
        set { fuerza = newValue / 2 }
    }
    
    init(vida: Int, fuerza: Int, poder: Poderes) {
        self.poder = poder
        super.init(vida: vida, fuerza: fuerza)
    }
    
    convenience init() {
        self.init(vida: 100, fuerza: 80, poder: .espada)
    }
    
    func lanzarAtaque() -> Int {
        return GKRandomDistribution.init(forDieWithSideCount: ataque).nextInt()
        //esto genera un número aleatorio como si lanzara un dado, y nos devuelve el siguiente entero
    }
}
let aragorn = Heroe(vida: 200, fuerza: 150, poder: .espada)
aragorn.ataque //devuelve 300
aragorn.lanzarAtaque()
/* A partir de aquí, cada vez que creemos un nuevo Luchador vamos a tener que repetir el código de lanzar el dado de la función lanzarAtaque, porque el protocolo nos obliga a incluir dicha función
 Esta repetición de código se puede evitar con la extensión de protocolo, pues las extensiones sí incluyen el código o implementación */
extension Luchador {
    func lanzarAtaque() -> Int {
        return GKRandomDistribution.init(forDieWithSideCount: ataque).nextInt()
    }
}
//Al implementar el código mediante la extensión del protocolo (es como poner una función por defecto), al crear una nueva clase no necesitamos incluir el método en cuestión, pues ya está implementado en la extensión
class Heroe2: Luchador {
    var fuerza = 100
    var ataque: Int {
        get { return fuerza * 2 }
        set { fuerza = newValue / 2 }
    }
    //el protocolo nos obliga a incluir la propiedad ataque, pero no el método porque tiene código por defecto definido en la extensión
    //pero si queremos modificar ese código por defecto lo podemos hacer con override
}
let boromir = Heroe2()
boromir.lanzarAtaque() //funciona sin haberlo definido en la clase Heroe2
