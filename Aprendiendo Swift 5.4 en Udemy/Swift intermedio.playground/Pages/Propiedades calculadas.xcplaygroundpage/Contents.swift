import Foundation

// PROPIEDADES CALCULADAS
// Son como cualquier otra propiedad pero que llevan dentro una pequeña función. Tienen dos partes: get y set
// La parte get es la que devuelve el valor; y la parte set es la que asigna un valor
struct area {
    var ancho: Float
    var alto: Float
    var centro: (x: Float, y: Float) {
        get { return (ancho / 2, alto / 2) }
        // si solo ponemos un get, éste se podría quitar y poner directamente el return y tendríamos una propiedad get-only: calcula el valor y lo devuelve, no almacena nada y no podemos asignarle un valor
    }
}
var unArea = area(ancho: 60.7, alto: 40.3)
unArea.centro
// Para poder asignar un valor a una propiedad calculada hay que hacerlo con set:
struct area2 {
    var ancho: Float
    var alto: Float
    var centro: (x: Float, y: Float) {
        get { return (ancho / 2, alto / 2) }
        set {
            ancho = newValue.x * 2
            alto = newValue.y * 2
        }
    }
}
var unArea2 = area2(ancho: 60.7, alto: 40.3)
unArea2.centro = (30.0, 40.0)


// OBSERVADORES DE PROPIEDADES: DIDSET y WILLSET
// Permite hacer algo justo cuando cambie el valor, y siempre hay que inicializar la propiedad a observar
var valorRango: Int = 0 {
    didSet {
        //por ejemplo que esté entre 0 y 100
        //valorRango = min(max(valorRango, 0), 100)
        //también podría ser
        if valorRango < 0 || valorRango > 100 {
            valorRango = oldValue
        }
    }
}

// willSet se ejecuta justo antes del cambio de valor
class GuerreraElfa {
    enum Estado {
        case vivo, muerto
    }
    var fuerza = 80
    var destreza = 120
    var ataque: Int {
        get { return fuerza + destreza }
        set (nuevoValor) {
            fuerza = Int(Float(nuevoValor) * 0.4)
            destreza = nuevoValor - fuerza
        }
    }
    
    var vida = 100 {
        didSet {
            if estado == .muerto {
                vida = 0
            }
        }
        willSet {
            //reacciona al cambio de un dato para que algo ocurra al cambiar ese dato. Se ejecuta antes que el didSet
            if newValue <= 0 {
                muerte()
            }
        }
    }
    var estado: Estado = .vivo
    
    func muerte() {
        print("Se quedó sin vida")
        estado = .muerto
    }
}
let guerrera = GuerreraElfa()
guerrera.vida = -10


// PROPIEDADES PEREZOSAS O LAZY
// Las propiedades perezosas no se ejecutan hasta que no accedemos a la propia propiedad; algo parecido a las propiedades calculadas
// El siguiente es un ejemplo de código para conectar con Facebook
class Facebook {
    /* si no ponemos lazy en la línea siguiente daría error porque no podemos usar self (no está disponible) hasta que se instancie un objeto, y por eso no podemos hacer la igualdad o asignación
     pero con lazy sí nos deja porque no accederá a la propiedad hasta que no se instancie el objeto, momento en que self ya está disponible*/
    lazy var fbName: String? = self.recuperadoDatos()
    
    func recuperadoDatos() -> String {
        print("Conecto a Facebook")
        print("Tardo mucho")
        let dato = "Spock"
        print("Terminé")
        return dato
    }
}
let fb = Facebook() //aquí todavía no se ha iniciado fbName, y por tanto no se ejecuta el código
fb.fbName //al llamar a la propiedad lazy ya se inicia y por tanto se ejecuta el código


// HERENCIA DE PROPIEDADES
// Se puede hacer override también de propiedades y no solo de métodos. Para las propiedades podemos sobreescribirlas y convertirlas en calculadas y/O añadirles observadores; no podemos cambiar su nombre ni su tipo
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
    }
}

class Enemigo: Personaje {
    enum Armas {
        case sable, arco, vara
    }
    var arma: Armas
    
    //sobrecarga de la propiedad vida (definida en el padre):
    override var vida: Int {
        get { return fuerza * 2 }
        set { self.fuerza = newValue * 2 }
    }
    
    //añadir observadores:
    override var fuerza: Int {
        willSet {
            if newValue < 0 {
                vida = 0
            }
        }
        didSet {
            if fuerza < 0 {
                fuerza = 0
            }
        }
    }
    
    init(vida: Int, fuerza: Int, arma: Armas) {
        self.arma = arma
        super.init(vida: vida, fuerza: fuerza)
    }
    
    convenience init() {
        self.init(vida: 50, fuerza: 20, arma: .sable)
    }
    
    required init(vida: Int, fuerza: Int) {
        self.arma = .arco
        super.init(vida: vida, fuerza: fuerza)
    }
}
let personaje1 = Personaje(vida: 20, fuerza: 30)
personaje1.fuerza = -10
personaje1.vida //no hace nada con la vida
let enemigo1 = Enemigo(vida: 20, fuerza: 30, arma: .sable)
enemigo1.fuerza = -10
enemigo1.vida //vida=0 porque lo cambiamos con los observadores
