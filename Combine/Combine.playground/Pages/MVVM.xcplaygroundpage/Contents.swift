//: [Previous](@previous)

import Combine
import PlaygroundSupport
import SwiftUI

// ARQUITECTURA MVVM CON SWIFTUI

// Combine permite a SwiftUI usar su propia arquitectura MVVM. Veamos un ejemplo simple de cómo los publicadores se integran en distintos componentes para emitir las señales. Hacer otra vez el reloj pero con MVVM

let dateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "es_ES")
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter
}()

// Este es el modelo:
final class ClockVM: ObservableObject {
    //este protocolo ObservableObject tiene un publicador que emite antes de que el objeto cambie, por lo que cualquier cambio del objeto hará que la vista se refresque
    @Published var hora = dateFormat.string(from: Date())
    
    var subscribers = Set<AnyCancellable>()
    
    init() {
        Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
            .autoconnect()
            .map { dateFormat.string(from: $0) }
            .assign(to: \.hora, on: self) //asignamos directamente porque el publicador no devuelve error
            .store(in: &subscribers)
    }
}

//Esta es la vista: se conecta con el modelo por un property wrapper
struct ClockView: View {
    @ObservedObject var clockVM = ClockVM() //ya está conectado al modelo, a su publicador
    
    @State var horaPublished = dateFormat.string(from: Date())
    @State var horaOWC = dateFormat.string(from: Date())
    
    var body: some View {
        VStack {
            Text("Desde el PUBLISHED")
                .font(.headline)
            Text("\(clockVM.hora)")
            //para ver cómo funciona, lo que hace internamente es lo siguiente
            Text("Desde el PUBLISHER")
                .font(.headline)
            Text("\(horaPublished)")
                .onReceive(clockVM.$hora) { time in
                    horaPublished = time
                }
            //este reloj va 1 seg por detrás porque ahora usaremos el will change, que emite antes de que cambie
            Text("Desde el OBJECT WILL CHANGE")
                .font(.headline)
            Text("\(horaOWC)")
                .onReceive(clockVM.objectWillChange) {
                    horaOWC = clockVM.hora
                }
        }
    }
}

PlaygroundPage.current.setLiveView(ClockView())



//: [Next](@next)
