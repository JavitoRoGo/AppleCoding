//: [Previous](@previous)

import Combine
import UIKit

// NOTIFICATION CENTER

// Se trata de la integración con el centro de notificaciones de Cocoa y Cocoa Touch a través de una implementación de Combine. Sirve para observar cualquier Post directamente con un publicador e incluso tratar los datos que acompañan a la notificación en cada emisión

extension Notification.Name {
    static let myNotification = Notification.Name("MiNotificación")
}

// Vamos a crear una clase publicadora que emita una señal a través del Notification Center, y una clase receptora que la reciba a través de un publicador

final class ClaseEmisora {
    var timer: Timer?
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            NotificationCenter.default.post(name: .myNotification, object: "Mensaje secreto \(Int.random(in: 1...50))")
        }
    }
}

final class ClaseReceptora {
    var mensaje = "" {
        //observador para comprobar los mensajes que va creando
        didSet {
            print("Nuevo mensaje: \(mensaje)")
        }
    }
    var subscribers = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default
            .publisher(for: .myNotification) //no propaga errores, es publicador de tipo Never
            .compactMap { $0.object as? String }
            .assign(to: \.mensaje, on: self)
            .store(in: &subscribers)
    }
}

let emisor = ClaseEmisora()
let receptor = ClaseReceptora()



//: [Next](@next)
