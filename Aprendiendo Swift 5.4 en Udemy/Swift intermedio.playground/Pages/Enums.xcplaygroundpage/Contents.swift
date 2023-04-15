import Foundation

// ENUMS
// Es un tipo de dato como puede ser Int, y alberga todos los casos que queramos contemplar
enum Generos {
    case aventuras, acción, comedia, scifi, drama, infantil
}
var genero1 = Generos.comedia
var genero2: Generos = .acción //al declarar el tipo basta con poner el punto después del igual y ya nos salen todos los case
if genero1 == .comedia {
    print("Es comedia")
}
// Una buena funcionalidad de los enums es hacer switch exhaustivos que no necesitan un default:
var frase = "Esta película es de tipo "
switch genero1 {
case .aventuras:
    frase += "aventuras."
case .acción:
    frase += "acción."
case .comedia:
    frase += "comedia."
case .scifi:
    frase += "scifi."
case .drama:
    frase += "drama."
case .infantil:
    frase += "infantil."
}
print(frase)

// Inicializar un enum con init, que es una función especial de enum, struct y class
enum Generos1 {
    case aventuras, acción, comedia, scifi, drama, infantil
    init() {
        self = .scifi
    }
}
var generos3 = Generos1() //es .scifi porque no hemos especificado valor pero coge la inicialización por defecto que nos da init

// Tipificar un enum y usar el rawValue: darle un tipo de dato en bruto y asignar incluso valores a cada case
enum Generos2: Int {
    case aventuras = 1, acción = 4, comedia = 8, scifi = 12, drama = 16, infantil = 20
}
var genero4 = Generos2.comedia
genero4.rawValue //devuelve 8 que es el valor que le hemos asignado
// Otro ejemplo:
enum Generos3: String {
    case aventuras
    case acción
    case comedia
    case scifi = "Ciencia ficción"
    case drama
    case infantil
}
var genero5 = Generos3.comedia
genero5.rawValue //devuelve "comedia", porque al ser string devuelve el propio nombre del case, aunque también se le pueden dar valores
