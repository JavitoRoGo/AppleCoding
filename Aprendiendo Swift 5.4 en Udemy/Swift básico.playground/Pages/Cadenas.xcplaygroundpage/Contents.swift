import Foundation

// CADENAS
// Es un tipo básico y fundamental. Permite operaciones como interpolación, concatenación o suma de cadenas o caracteres, búsqueda, contar, etc.
var stringVacio = String()
stringVacio += "123"
stringVacio.count
stringVacio.isEmpty
stringVacio.hasPrefix("algo")
stringVacio.hasSuffix("algo")
stringVacio.contains("lo que sea")
stringVacio.range(of: "3")
if let range = stringVacio.range(of: "3") {
    print(stringVacio[range])
    //nos da el rango dentro de la cadena donde está el texto que indicamos, y con ese rango o índice podemos aislar la subcadena correspondiente a ese índice, como si fuera un array
}


// Uso de subcadenas, con string.index
let cadena = "A long time ago in a galaxy far far away"
let cadena2 = "One ring to rule them all"
// índices de inicio y fin de cadena:
let inicio = cadena.startIndex
let final = cadena.endIndex
// índice de una posición determinada (la del caracter 7 por ejemplo):
let posicion1 = cadena.index(inicio, offsetBy: 7)
let posicion2 = cadena.index(inicio, offsetBy: 14)
// extraer subcadena. OJO, es de tipo substring, que habría que volver a transformar en string para trabajo con otros string
cadena[posicion1...posicion2]
let subcadena = cadena[posicion1...posicion2]
let subcadenaFinal = String(subcadena)


// Más funcionalidades de las cadenas:
cadena.uppercased()
cadena.lowercased()
cadena.capitalized
// la siguiente separa la cadena en componentes, devolviendo un array con los componentes que salen tras dividir con el texto que le indiquemos:
cadena.components(separatedBy: " ")
// la siguiente rellena con el caracter que indiquemos hasta el número indicado, como el caso típico de un índice con línea de puntos:
cadena.padding(toLength: 150, withPad: ".", startingAt: 0)
// buscar y reemplazar:
cadena.replacingOccurrences(of: "busca", with: "reemplaza")



// CADENAS EN BRUTO
let frase = "Hay que tener en cuenta algunas \"cosas\"."
// Para que un texto tenga comillas, y distinguirlas en el código de las de apertura y cierre de string, se usa un caracter de escape con la barra \
// Se puede evitar lo anterior y hacer que cualquier cosa que se escriba sea parte de la cadena, sin caracteres de escape, usando las cadenas en bruto, que se abren y cierran con #" "#
let fraseRaw = #"Hay que tener en cuenta "algunas cosas"."#
// Para interpolar en una cadena en bruto se hace también con #:
let nombre = "Antonio"
let interpolarRaw = #"Su nombre era \#(nombre)"#
// Para incluir # dentro de la cadena se empieza y termina con ##

// Si queremos cadenas multilinea es con 3 comillas
let multilinea = """
    Así se hace
    una cadena
    multilinea
    """
let multilineaRaw = #"""
Multilinea en bruto
e incluso interpolando
para \#(nombre)
"""#

// Podemos buscar expresiones regulares y comprobar si están bien y son funcionales. En el siguiente ejemplo se da un mail bien escrito y otro mal, y se hace la búsqueda para ver si está bien
let emailRegEx = #"^[^@]+@[^@]+\.[a-zA-Z]{2,}$"# //esto es la expresión regular de un email
let email = "paquito@flores.net"
let emailNO = "antonio#pepe"
let emailOK1 = email.range(of: emailRegEx, options: .regularExpression)
let emailOK2 = emailNO.range(of: emailRegEx, options: .regularExpression) //esta devuelve nil
// Cómo ver si en la cadena hay solo 1 email, comparando los índices de inicio y fin
if emailOK1?.lowerBound == email.startIndex && emailOK1?.upperBound == email.endIndex {
    print("Solo hay un email")
}
