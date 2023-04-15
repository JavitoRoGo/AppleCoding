//: [Previous](@previous)

import Combine
import Foundation

// SUJETOS DE VALOR ACTUAL

// Los sujetos son elementos que actúan como publicadores y nos permiten personalizar el flujo de trabajo
// Los de valor actual permiten unir el paradigma imperativo con el declarativo
// Un sujeto es un publicador que yo declaro y que permite emitir los valores que queramos. Se puede trabajar con ellos de forma imperativa (siempre se está pendiente de los cambios) y declarativa.
// Veamos primero la forma imperativa: el sujeto de valor actual

let subject = CurrentValueSubject<Int,Never>(0) // es un publicador de declaración imperativa que almacena el valor y los sucesivos cambios. Se declara indicando el tipo de success y failure, y entre paréntesis el valor inicial del success
// es como una variable en la que puedo ir almacenando valores, y "alguien" va a estar pendiente de esos cambios
subject.value //nos permite ver el valor actual
// Para emitir valores:
subject.send(1)
subject.send(2)
subject.value
// Es decir, es como una variable que almacena valores con .send, y a la vez los emite:

let subscription = subject.sink(receiveValue: { print("Recibí el valor \($0)")} )
// En el momento que se crea el suscriptor, recibe el último valor que haya emitido el sujeto de valor actual (2 en el ejemplo), y a partir de ahí irá recibiendo las sucesivas publicaciones
subject.send(3) //ahora recibe el 3

// Podemos finalizar el suscriptor enviando la señal de finalización
subject.send(completion: .finished)
subject.send(4) //el publicador emite pero el suscriptor no recibe esta señal porque ya le dijimos que terminara


//: [Next](@next)
