import Foundation

// PROGRAMACIÓN ORIENTADA A OBJETOS
// Las clases definen (hacen una abstracción) características como son propiedades y métodos, y sirven para instanciar o crear objetos
// Con la herencia de clases podemos crear una nueva clase que hereda las propiedades y métodos de la que proviene, pero puede añadir nueva características

// Crear una clase e instanciar un objeto
class Test {
    var propiedad: Int?
    func metodo() {
        
    }
}
let test = Test()
// Crear una herencia de Test con una nueva propiedad
class TestHijo: Test {
    var nuevaPropiedad: Int?
}
let testHijo = TestHijo()

// Más ejemplos de clases y objetos. Los objetos se instancian como let porque son valores por referencia, apuntan a una clase concreta, y eso no va a cambiar. Pero eso no quita que podamos modificar sus propiedades siempre que se declaren como var
class Personaje {
    var vida = 100
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
}
let heroe = Personaje()
heroe.vida //devuelve 100
heroe.pierdeVida(cantidad: 20)
heroe.vida //devuelve 80
let heroe2 = Personaje()
heroe2.vida //100


// INICIALIZADORES DESIGNADOS O PRINCIPALES
// Regla de oro: una clase tiene que tener SIEMPRE todas sus propiedades inicializdos para poder ser una estructura básica, bien dándoles un valor directamente o usando un inicializador
class Personaje2 {
    var vida: Int
    var fuerza: Int
    var magia: Int? //si es opcional no da error la clase porque ya está inicializado como nil
    var muerto = false //ya tiene valor y no hay que ponerlo en el init
    func pierdeVida(cantidad: Int) {
        vida -= cantidad
        if vida <= 0 {
            haMuerto()
        }
    }
    func haMuerto() {
        muerto = true
    }
    init(vida: Int) {
        self.vida = vida
        self.fuerza = 40
    }
    //se pueden poner varios init pero con diferentes parámetros de entrada, pero siempre inicializando TODAS las propiedades
    init(vida: Int, fuerza: Int) {
        self.vida = vida
        self.fuerza = fuerza
    }
    init(fuerza: Int) {
        self.vida = 100
        self.fuerza = fuerza
    }
    init() {
        self.vida = 100
        self.fuerza = 20
    }
}
//se puede usar cualquiera de los dos init a la hora de instanciar un objeto
let personaje = Personaje2(vida: 80)
let personaje2 = Personaje2(vida: 120, fuerza: 80)


// Inicializadores de conveniencia o secundarios
// Inicializa la clase pero debe apoyarse en uno principal para completar el trabajo
class Personaje3 {
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
    init(vida: Int) {
        self.vida = vida
        self.fuerza = 40
    }
    init(vida: Int, fuerza: Int) {
        self.vida = vida
        self.fuerza = fuerza
    }
    init(fuerza: Int) {
        self.vida = 100
        self.fuerza = fuerza
    }
    convenience init() {
        self.init(vida: 100, fuerza: 40) //hay que llamar a este init principal antes de usar las propiedades
        self.vida += 20
        self.fuerza = 20
    }
}


// HERENCIA DE CLASES
// Clase que hereda las propiedades y métodos del padre, y puede añadir otras
// Aclaración: self es la referencia a sí mismo; y super es la referencia al padre
class Heroe: Personaje3 {
    enum Poderes {
        case espada, magia, saltar
    }
    var poder: Poderes
    
    init(vida: Int, fuerza: Int, poder: Poderes) {
        self.poder = poder
        super.init(vida: vida, fuerza: fuerza)
        //después de inicializar todas la propiedades no inicializadas del hijo, hay que inicializar el padre a través de un principal
    }
    
    convenience init() {
        //desde un inicializador secundario del hijo no puedo llamar a ningún principal, ni de padre ni de hijo. Solo puedo llamar a un inicializador principal del hijo
        self.init(vida: 100, fuerza: 80, poder: .espada)
    }
}
let ladrona = Heroe(vida: 120, fuerza: 60, poder: .saltar)
let mago = Heroe(vida: 60, fuerza: 50, poder: .magia)
let guerrero = Heroe(vida: 150, fuerza: 100, poder: .espada)


// Sobreescritura o sobrecarga de métodos del padre en el hijo
// Veamos un ejemplo como si fuera una partida: vamos a sobreescribir el método haMuerto para que cuando muera un enemigo, a los puntos se le sume la fuerza del enemigo muerto
var partida = true
var puntos = 0
class Enemigo: Personaje3 {
    enum Armas {
        case sable, arco, vara
    }
    var arma: Armas
    
    init(vida: Int, fuerza: Int, arma: Armas) {
        self.arma = arma
        super.init(vida: vida, fuerza: fuerza)
    }
    
    convenience init() {
        self.init(vida: 50, fuerza: 20, arma: .sable)
    }
    
    override func haMuerto() {
        puntos += fuerza
        //sobreescritura de métodos del padre, pero OJO!!! solo con la línea anterior se perdería la funcionalidad del método padre (que es cambiar muerto a true), porque lo estamos sobreescribiendo
        //para que el método del padre también ejecute su código hay que llamar al super
        super.haMuerto()
    }
}
let enemigo1 = Enemigo()
let enemigo2 = Enemigo(vida: 20, fuerza: 30, arma: .arco)
puntos //devuelve 0
enemigo2.pierdeVida(cantidad: 25)
enemigo2.muerto //devuelve true
puntos //devuelve 30
//igualmente podríamos override el método haMuerto de la clase Heroe para que cambie partida a false


// Inicializadores por defecto o required, que se incluyen en el padre y nos obliga por tanto a sobreescribirlos en los hijos
class Personaje4 {
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
    init(vida: Int) {
        self.vida = vida
        self.fuerza = 40
    }
    required init(vida: Int, fuerza: Int) {
        self.vida = vida
        self.fuerza = fuerza
    }
    init(fuerza: Int) {
        self.vida = 100
        self.fuerza = fuerza
    }
    convenience init() {
        self.init(vida: 100, fuerza: 40)
        self.vida += 20
        self.fuerza = 20
    }
}
class Heroe2: Personaje4 {
    enum Poderes {
        case espada, magia, saltar
    }
    var poder: Poderes
    
    init(vida: Int, fuerza: Int, poder: Poderes) {
        self.poder = poder
        super.init(vida: vida, fuerza: fuerza)
    }
    
    convenience init() {
        self.init(vida: 100, fuerza: 80, poder: .espada)
    }
    
    required init(vida: Int, fuerza: Int) {
        //fatalError("init(vida:fuerza:) has not been implemented")
        //la línea anterior la añade swift y lo que haría es salirse del programa al usar este init (por eso se ha comentado), para obligarnos a cambiarla y que haga alguna acción concreta. Por ejemplo:
        self.poder = .espada
        super.init(vida: vida, fuerza: fuerza)
    }
    
    override func haMuerto() {
        partida = false
        super.haMuerto()
    }
}


// Clases y métodos finales: si hacemos final un método no se podrá sobrecargar en los hijos; y si hacemos final una clase, no podrá tener hijos
// Si una clase que creemos no va a tener herencia, Apple nos recomienda que la hagamos final para ahorrar memoria y que la app vaya más rápida
final class Enemigo2: Personaje3 {
    enum Armas {
        case sable, arco, vara
    }
    var arma: Armas
    
    init(vida: Int, fuerza: Int, arma: Armas) {
        self.arma = arma
        super.init(vida: vida, fuerza: fuerza)
    }
    
    convenience init() {
        self.init(vida: 50, fuerza: 20, arma: .sable)
    }
    
    override func haMuerto() {
        puntos += fuerza
        super.haMuerto()
    }
}


// DEINICIALIZADORES DEINIT
// Es algo así como que la clase haga algo cuando va a salir de memoria, cuando se va a "desinicializar". Ejemplo con un timer que suma un punto de vida cada 60 segundos
class Personaje5 {
    var vida: Int
    var fuerza: Int
    var muerto = false
    
    var timer: Timer?
    
    func pierdeVida(cantidad: Int) {
        vida -= cantidad
        if vida <= 0 {
            haMuerto()
        }
    }
    func haMuerto() {
        muerto = true
    }
    init(vida: Int) {
        self.vida = vida
        self.fuerza = 40
    }
    required init(vida: Int, fuerza: Int) {
        self.vida = vida
        self.fuerza = fuerza
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(sumaPunto), userInfo: nil, repeats: true)
        //la línea anterior crea un timer que cada 60s llama a sumaPunto y luego vuelve a empezar (se repite)
        //si se acaba la partida este timer seguiría funcionando en segundo plano, y por eso hay que pararlo, que se haría con deinit
    }
    init(fuerza: Int) {
        self.vida = 100
        self.fuerza = fuerza
    }
    
    @objc func sumaPunto() {
        vida += 1
    }
    
    convenience init() {
        self.init(vida: 100, fuerza: 40)
        self.vida += 20
        self.fuerza = 20
    }
    
    deinit {
        //lo que haya aquí se ejecuta al final, cuando la clase vaya a morir porque se eliminará de memoria
        //es algo parecido al defer de las funciones, que se ejecuta siempre al final de la función
        if let timer = timer {
            timer.invalidate()
        }
    }
}
