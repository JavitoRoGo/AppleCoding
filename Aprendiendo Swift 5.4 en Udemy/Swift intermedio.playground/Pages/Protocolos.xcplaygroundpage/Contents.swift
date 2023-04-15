import Foundation
import UIKit

// PROTOCOLOS
// Son plantillas o requisitos a cumplir por parte de un struct o clase, y por tanto recoje la estructura que tiene que cumplir y no el código
// Se usan para garantizar una funcionalidad, para que un struct o clase tenga un método llamado de determinada forma (aunque el código va en la propia clase)
// Las propiedades incluidas en un protocolo solo pueden ser calculadas
// Ejemplo:
class Bicho: CustomStringConvertible {
    var nombre: String
    var color: UIColor
    
    var description: String {
        //se trata de una propiedad calculada que tenemos que definir al conformar la clase al protocolo por defecto CustomStringConvertible
        //el protocolo en este caso obliga a definir esta propiedad, el protocolo la incluye o crea pero no tiene el código
        return self.nombre
    }
    
    init(nombre: String, color: UIColor) {
        self.nombre = nombre
        self.color = color
    }
}
let bichito = Bicho(nombre:"Zargáfilo", color:.green)
print(bichito) //con el protocolo de arriba se imprime el nombre que definimos


// CREAR UN PROTOCOLO
protocol miProtocolo {
    //dentro solo va la cabecera o especificación, no el código
    mutating func miFuncion() //el mutating viene de un ejemplo más adelante
    var miVariable: Int { get }
}
class miClase: miProtocolo {
    var miVariable: Int {
        get { return 0 }
    }
    func miFuncion() {
        //aquí va el código que queramos de la función; lo que nos obliga el protocolo es a que exista esta función
    }
}
// También vale para struct y enum
struct miStruct: miProtocolo {
    var miVariable: Int = 0
    func miFuncion() {
        
    }
}
enum miEnum: miProtocolo {
    var miVariable: Int {
        get { return 0 }
    }
    func miFuncion() {
        
    }
}


// HERENCIA DE PROTOCOLOS
// Es como una suma de requisitos: si un protocolo se basa (o hereda) en otro sus requisitos se suman
protocol miProtocolo2: miProtocolo {
    //no hay que poner los requisitos del padre
    init(arg: Int)
    func miFuncion(num: Int)
}
class miClase2: miProtocolo {
    var miVariable: Int = 0
    func miFuncion() {
        
    }
}
class miClase3: miProtocolo2 {
    var miVariable: Int = 0
    func miFuncion() {
        
    }
    func miFuncion(num: Int) {
        //permite el polimorfismo o sobrecarga
    }
    required init(arg: Int) {
        //el init pasa a ser requerido
    }
}


// CASOS ESPECIALES
// 1.- Modificar parámetros en struct
struct miStruct2: miProtocolo {
    var miVariable: Int = 0
    mutating func miFuncion() {
        miVariable += 1
        //ponemos el mutating en func para que deje modificar la propiedad (recordar que los struct son inmutables), pero daría error
        //por ello ponemos mutating también en el protocolo
    }
}

// 2.- Crear un protocolo exclusivo para clases, que no funcionaría con struct o enum
protocol onlyClass: AnyObject {
    
}

// 3.- Los protocolos de swift son obligatorios, hay que cumplir obligatoriamente con todas las características. Pero se puede convertir en objective-c y así incluir opcionales
@objc protocol miProtocolo3 {
    func miFuncion()
    @objc optional var miVariable: Int { get }
    //así no es obligatorio incluir la propiedad. También vale para métodos
}


// Ejemplo práctico de uso de protocolo
protocol Coloreable {
    //queremos que cualquier objeto se pueda colorear, que cualquier objeto que se cree pueda cambiar su color
    mutating func colorear(color: UIColor)
}
class boton: UIButton, Coloreable {
    func colorear(color: UIColor) {
        self.setTitleColor(color, for: .normal)
        //cambia el color del botón al color que le digamos para el estado normal del botón
    }
    func mostrar() {
        self.isHidden = true
    }
}
struct listas: Coloreable {
    //crea una lista de datos y con el protocolo podemos cambiar el color
    var color: UIColor
    var datos = [String]()
    
    mutating func colorear(color: UIColor) {
        self.color = color
    }
}
// Vemos que la implementación (el código) de la función colorear varía y depende del objeto que vaya a cambiar de color; pero el protocolo nos va a obligar a incluirla siempre

//creamos un botón con nuestra clase y cambiamos su color directamente con la propiedad que viene del protocolo
let nuevoBoton = boton()
nuevoBoton.colorear(color: .green)
//lo mismo: creamos lista con nuestro struct y luego aplicamos el cambio de color
var nuevaLista = listas(color: .blue, datos: ["Dato1", "Dato2", "Dato3"])
nuevaLista.color //devuelve azul
nuevaLista.colorear(color: .cyan)
nuevaLista.color //devuelve cyan


// PROTOCOLOS COMO TIPOS DE DATOS
// Cuando hacíamos un array de diferentes tipos de datos había que conformarlos a Any, que realmente es un protocolo y no un tipo de dato
// Otro ejemplo con clases
let nuevoBoton1 = boton()
let nuevoBoton2 = boton()
let nuevoBoton3 = UIButton()

var nuevaLista1 = listas(color: .black, datos: ["1", "2", "3"])
var nuevaLista2 = listas(color: .brown, datos: ["4", "5", "6"])

var mundoColor = [Coloreable]() //array del protocolo, por lo que podremos guardar ahí cualquier objeto (instancia de clase o struct) que cumpla con él o se haya conformado
mundoColor.append(nuevoBoton1)
mundoColor.append(nuevoBoton2)
//nuevoBoton3 no se puede añadir porque no está conformado a Coloreable
mundoColor.append(nuevaLista1)
mundoColor.append(nuevaLista2)
//al añadir los elementos al array se hace upcasting y se pierde el tipo de dato, como ya se vio en su momento
//al sacarlo del array hay que hacer el downcasting
let botonN = mundoColor[1] as! boton
