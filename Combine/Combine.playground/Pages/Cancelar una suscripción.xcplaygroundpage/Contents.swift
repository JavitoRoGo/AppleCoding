//: [Previous](@previous)

import Combine
import Foundation

// CANCELANDO UNA SUSCRIPCIÓN

// Podemos cancelar una suscripción para que deje de escuchar y recibir señales, a pesar de que el publicador siga emitiendo. Hasta ahora, lo visto en los ejemplos es que se cancela el publicador mediante la señal de finalización.
// Pero ahora veremos cómo cancelar el suscriptor de tipo AnyCancelable con su función .cancel

let subject = PassthroughSubject<String, Never>()

let subscriber = subject.sink(receiveValue: { resultado in
    print(resultado)
})

subject.send("A")
sleep(1)
subject.send("Long")
sleep(1)
subject.send("Time")
sleep(1)
subject.send("Ago")
sleep(1)
subject.send("in")
sleep(1)
subject.send("a")
sleep(1)
subscriber.cancel() //a partir de aquí se cancela el suscriptor pero el publicador sigue emitiendo
subject.send("galaxy")
sleep(1)
subject.send("far")
sleep(1)
subject.send("far")
sleep(1)
subject.send("away")

subject.send(completion: .finished)


//: [Next](@next)
