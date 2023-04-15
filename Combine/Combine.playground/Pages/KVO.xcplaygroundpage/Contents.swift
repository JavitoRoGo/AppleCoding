//: [Previous](@previous)

import Combine
import Foundation

// KVO - KEY VALUE OBSERVER

// Combine también funciona contra las propiedades de cualquier objeto de Objective-C que sea hijo de NSObject. Veamos cómo implementar el patrón de observadores de valores clave (KVO) para recibir una señal de un publicador, en una forma similar a los didSet de Swift

final class Test: NSObject {
    @objc dynamic var propiedad: Int = 0
}

// Cualquier hijo de NSObject tiene como propiedad un publicacor

let test = Test()
test.publisher(for: \.propiedad)
    .map {
        print("Recibido el valor \($0)")
        return $0
    }
    .sink { print($0) }

test.propiedad = 1
sleep(1)
test.propiedad = 2
sleep(1)
test.propiedad = 3
sleep(1)
test.propiedad = 4


//: [Next](@next)
