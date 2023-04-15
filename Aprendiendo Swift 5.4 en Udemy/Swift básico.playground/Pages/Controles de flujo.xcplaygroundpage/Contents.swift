import Foundation

// Un ámbito es aquello que se declara entre llaves, como una función, for, if, struct, etc. Lo que se declare en un ámbito solo existirá en él pero no fuera del mismo: las variables creadas dentro de for no estarán disponibles fuera del bucle.


// IF
// El control if valora una condición que puede ser true o false. En los if anidados hay que tener cuidado en el orden en que se declaran porque solo se ejecuta uno: es decir, una vez que un if o else if es true, ejecuta su código y no hace más comprobaciones.

// SWITCH
// El control switch debe ser exhaustivo y contemplar todos los casos, para lo que se usa al final un default. Encajan perfecto con un enum, en cuyo caso no necesitan el dafault. Cuando un case cumple, ejecuta el código y sale del switch, no valora más.
// Si queremos de el defautl no haga nada ponemos ().

// FOR
// El bucle for-in ejecuta el código de su ámbito un número determinado de veces, y nos permite capturar en una constante un valor. Una variación del for es usando la sentencia where. En el ejemplo siguiente, el bucle se ejecuta 10 veces, es decir, 10 veces se comprueba si indice%2=0, pero solo 5 veces entra dentro de if e imprime:
for indice in 1...10 {
    if indice % 2 == 0 {
        print(indice)
    }
}
// Una forma más eficiente de hacerlo es con where, de tal forma que el bucle se ejecuta solo 5 veces, que son las veces que se cumple la sentencia de where. Es más eficiente a nivel de menos código escrito, y menos memoria utilizada:
for indice in 1...10 where indice % 2 == 0 {
    print(indice)
}
// Un bucle for también se puede configurar para que no cubra todos los valores de manera secuencial. En el siguiente ejemplo, recorre los valores de 1 a 20 pero de 3 en 3:
for indice in stride(from: 1, to: 25, by: 4) {
    print(indice)
}
for indice in stride(from: 1, through: 25, by: 4) {
    print(indice)
}
// El primer caso empieza el bucle en el valor from y llega hasta to pero sin incluirlo (como un rango abierto), mientras que en el segundo caso sí incluye el límite superior

// WHILE Y REPEAT WHILE
// Lo primero a tener en cuenta: OJO, estos bucles pueden ser infinitos.
// Con repeat se ejecuta el código una vez al menos, y al finalizar se analiza la condición. Mientras que solo con while, primero analiza la condición y luego ejecuta el código, por lo que puede ser que no se ejecute ni una vez si la condición no es true. Ejemplo:
var valor: Int
let acierto = Int.random(in: 1...20)
print("Buscando el número \(acierto)")
repeat {
    valor = Int.random(in: 1...20)
    print("Ha salido el valor \(valor)")
} while acierto != valor

var valor2 = -1 // lo ponemos negativo de entrada para que al menos una vez entre el bucle while
let acierto2 = Int.random(in: 1...20)
print("Buscando el número2 \(acierto2)")
while acierto2 != valor2 {
    valor2 = Int.random(in: 1...20)
    // valor2 = 22 si hacemos algo así tendríamos un bucle infinito que nunca termina y bloquearía la app
    print("Ha salido el valor \(valor2)")
}



// CONTROL DE TRANSFERENCIA EN BUCLES Y ETIQUETAS
// Se trata de controlar el flujo de los bucles para terminarlos, seguir, o que pasen al siguiente case: break, continue y fallthrough
// Break
let acierto3 = (Int(arc4random()) % 20) + 1 //aleatorio de 1 a 20
for indice in 1...20 {
    if acierto3 != indice {
        print("Buscando el número \(acierto3). Voy por el \(indice).")
    } else {
        break //esto para el bucle, que sin el break se ejecutaría las 20 veces del for, pero así se para en cuento la condición sea falsa (o sea, que encontramos el número)
    }
}

// Continue
let dato1 = Int.random(in: 1...200)
let dato2 = Int.random(in: 1...200)
let dato3 = Int.random(in: 1...200)
for i in 1...200 {
    if i != dato1 && i != dato2 && i != dato3 {
        continue
        //así se optimiza el switch, que solo se ejecutará cuando los 3 datos sean iguales a i
        //lo que hace continue es saltarse todo el código e ir al siguiente valor del bucle for (mientras que break rompe el bucle y se sale)
    }
    switch i {
    case dato1:
        print("Encontrado dato 1: \(dato1)")
    case dato2:
        print("Encontrado dato 2: \(dato2)")
    case dato3:
        print("Encontrado dato 3: \(dato3)")
    default:
        ()
    }
}

// Fallthrough
let x = Int.random(in: 1...10)
switch x {
case 1,2,3,4,5:
    print("Entre 1 y 5")
case 6:
    fallthrough
    //lo que hace esta instrucción es ejecutar el código y saltar al siguiente case y ejecutarlo (en lugar de terminar el switch), independientemente que el siguiente case cumpla o no la condición
    //cuando salga 6 saltará y ejecutará el siguiente case
case 7:
    print("6 o 7")
default:
    print("Mayor que 7")
}

// ETIQUETAS
// Se usan para nombrar los bucles cuando están anidados, para que el sistema sepa dónde ir en caso de continue o break. Se pone el nombre o etiqueta con : antes del bucle a nombrar
var valor3: Int = -1
var intentos = 0
print("Buscando el número \(acierto2)") //aleatorio de 1 a 20 creado antes
busqueda: while acierto2 != valor3 {
    valor3 = Int.random(in: 1...20)
    buscar: for _ in 1...20 {
        if acierto2 != valor3 {
            intentos += 1
            continue busqueda
        } else {
            break buscar
        }
    }
    print("Evaluamos nuevo caso")
}
print("Enhorabuena. Salió el \(valor3) al intento número \(intentos).")
