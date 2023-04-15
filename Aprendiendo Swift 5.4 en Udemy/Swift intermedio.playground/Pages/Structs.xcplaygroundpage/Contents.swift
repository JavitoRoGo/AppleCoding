import Foundation

// STRUCTS
// Son parecidos a las clases, aunque son un tipo de dato por valor y no por referencia, y no tienen herencia. Además, cuentan con un inicializador por defecto (el inicializador sintetizado nos pide todas las propiedades no inicializadas previamente)
struct Empleado {
    enum Departamentos {
        case contabilidad, informática, administración, diseño
    }
    let nombre: String
    let apellidos: String
    let departamento: Departamentos
    var salario: Double
}
let empleado1 = Empleado(nombre: "Paco", apellidos: "Fernández", departamento: .contabilidad, salario: 30000)

// Pero también podemos hacer nuestros init, teniendo en cuenta que al declararlos el sintetizado desaparece, pero podemos hacer todos los que queramos
// Todos los que creemos serán principales, que es otra diferencia con las clases
struct Empleado2 {
    enum Departamentos {
        case contabilidad, informática, administración, diseño
    }
    let nombre: String
    let apellidos: String
    let departamento: Departamentos
    var salario: Double
    
    init(contabilidad nombre: String, apellidos: String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.departamento = .contabilidad
        self.salario = 30000
    }
    init(nombre: String, apellidos: String, departamento: Departamentos, salario: Double) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.departamento = departamento
        self.salario = salario
    }
    init(informatica nombre: String, apellidos: String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.departamento = .informática
        self.salario = 40000
    }
    
    func impuesto() -> Double {
        //podemos crear métodos como en las clases
        var retencion = 0.12
        switch salario {
            //recordar que con case let podemos capturar el valor para usarlo con where
        case let sueldo where sueldo > 35000: retencion = 0.42
        case let sueldo where sueldo > 29000: retencion = 0.33
        case let sueldo where sueldo > 24000: retencion = 0.25
        case let sueldo where sueldo > 16000: retencion = 0.18
        default: ()
        }
        return salario * retencion
    }
}
let empleado2 = Empleado2(contabilidad: "Paco", apellidos: "Pérez")
let empleado3 = Empleado2(informatica: "Sheldon", apellidos: "Cooper")


// Acceder a los datos con let y crear métodos
// Al ser un tipo de dato por valor, el objeto instanciado sí apunta a los datos (recordar que en las clases o dato por referencia, los objetos apuntan a la dirección de memoria de la clase, por lo que se pueden cambiar las propiedades a pesar de crear el objeto con let).
// Esto quiere decir que si instanciamos un objeto con let NO podrá modificarse de ninguna manera
//empleado3.salario = 50000 //da error porque el objeto empleado3 es let, a pesar de que salario se declaró como var


// Modificación de propiedades con mutating: todo el self (o sea, todo el struct) es constante o inmutable, por lo que ningún método va a poder modificar ninguna propiedad
// Para solventar esto se usa mutating con el método que queramos que modifique una propiedad
// Ejemplo con la función subirSalario
struct Empleado3 {
    enum Departamentos {
        case contabilidad, informática, administración, diseño
    }
    let nombre: String
    let apellidos: String
    let departamento: Departamentos
    var salario: Double
    
    init(contabilidad nombre: String, apellidos: String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.departamento = .contabilidad
        self.salario = 30000
    }
    init(nombre: String, apellidos: String, departamento: Departamentos, salario: Double) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.departamento = departamento
        self.salario = salario
    }
    init(informatica nombre: String, apellidos: String) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.departamento = .informática
        self.salario = 40000
    }
    
    func impuesto() -> Double {
        var retencion = 0.12
        switch salario {
        case let sueldo where sueldo > 35000: retencion = 0.42
        case let sueldo where sueldo > 29000: retencion = 0.33
        case let sueldo where sueldo > 24000: retencion = 0.25
        case let sueldo where sueldo > 16000: retencion = 0.18
        default: ()
        }
        return salario * retencion
    }
    
    mutating func subirSalario(aumento: Double) {
        self.salario += aumento
    }
}
var empleado4 = Empleado3(contabilidad: "Juan", apellidos: "Pérez")
empleado4.subirSalario(aumento: 10000)
