//: [Previous](@previous)

import Combine
import PlaygroundSupport
import SwiftUI

// TIMER O TEMPORIZADORES

// Es otra de las integraciones de Cocoa con Combine. Veamos como implementarlos mediante publicadores para cada que expire, obtener una señal a través de un publicador que podemos gestionar
// Vamos a crear un reloj como ejemplo, que comience con la hora actual y luego va sumando un segundo: haremos un publicador y, con un modificador de SwiftUI (onReceive), haremos que el receptor sea la vista

let dateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_ES")
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter
}()

struct MyClock: View {
    let timer = Timer
        .TimerPublisher(interval: 1, runLoop: .main, mode: .default)
        .autoconnect() //para que se conecte y se inicie, y luego se pare solo
        .map { dateFormat.string(from: $0) }
    
    @State var hora = dateFormat.string(from: Date())
    
    var body: some View {
        VStack {
            Text("\(hora)")
                .frame(width: 200)
        }
        .onReceive(timer) { time in
            hora = time
        }
    }
}

PlaygroundPage.current.setLiveView(MyClock()) //para ver la vista en el playground





//: [Next](@next)
