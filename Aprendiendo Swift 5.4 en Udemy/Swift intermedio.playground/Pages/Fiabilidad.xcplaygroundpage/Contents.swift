import Foundation
import Darwin

// FUNCIONES E INICIALIZADORES FIABLES
// Se trata de que una función o un init no haga aquello que tiene que hacer si recibe unos datos que no son los adecuados, y por tanto devuelva nil
// Función falible es por tanto la que devuelve un opcional, porque puede fallar
func sumar(numeros: [Int]) -> Int {
    if numeros.isEmpty {
        return 0
    }
    var resultado = 0
    for numero in numeros {
        resultado += numero
    }
    return resultado
}
var numeros1 = [Int]()
var numeros2 = [2,5,8,10,15,18]
var numeros3 = [-2,5,-3]
sumar(numeros: numeros1) //devuelve 0 porque es un array vacío
sumar(numeros: numeros2)
sumar(numeros: numeros3) //devuelve 0 porque la suma da 0, y podría confundirmos con el primer caso, así que mejor que devuelva nil si está vacío:
func sumar2(numeros: [Int]) -> Int? {
    if numeros.isEmpty {
        return nil
    }
    var resultado = 0
    for numero in numeros {
        resultado += numero
    }
    return resultado
}
sumar2(numeros: numeros1) //ahora devuelve nil, es decir, devuelve siempre un opcional
if let resultado1 = sumar2(numeros: numeros3) {
    print(resultado1)
}


// INIT FALIBLES: que una clase no se inicialice si tiene valores no válidos, que no se instancie el objeto
// Nos permite no inicializar la clase o instanciar el objeto si el dato no tiene sentido
// Por ejemplo, evitar en el caso siguiente que se pueda instaciar un objeto con String vacío
class Compositor {
    var name: String
    
    init?(name: String) {
        //OJO: las instancias de este init serán opcionales
        self.name = name
        if name.isEmpty {
            return nil
        }
    }
    init() {
        //con el init normal los objetos no son opcionales
        self.name = "Desconocido"
    }
}
let compositor1 = Compositor(name: "Joel McNeely") //se instancia pero es opcional
let compositor2 = Compositor(name: "") //en este caso devuelve nil y no se instancia
let compositor3 = Compositor() //este no es opcional


// INIT FALIBLES PARA STRUCT Y ENUM
struct CompositorStruct {
    var name: String
    
    init?(name: String) {
        //OJO: las instancias de este init serán opcionales
        self.name = name
        if name.isEmpty {
            return nil
        }
    }
    init() {
        //con el init normal los objetos no son opcionales
        self.name = "Desconocido"
    }
}

enum Semana: String {
    case lunes,martes,miércoles,jueves,viernes,sábado,domingo
}
let dia1: Semana = .martes //inicializador habitual, crea directamente el valor
let dia2 = Semana(rawValue: "lunnees") //inicializador en bruto o por rawValue: es falible porque si el valor no existe devuelve nil
enum Semana2 {
    case lunes,martes,miércoles,jueves,viernes,sábado,domingo
    init?(valor: Character) {
        switch valor {
        case "L", "l": self = .lunes
        case "M", "m": self = .martes
        case "X", "x": self = .miércoles
        case "J", "j": self = .jueves
        case "V", "v": self = .viernes
        case "S", "s": self = .sábado
        case "D", "d": self = .domingo
        default: return nil
        }
    }
}
let dia3 = Semana2(valor: "l") //es un opcional
let dia4: Semana2 = .lunes //no es opcional
