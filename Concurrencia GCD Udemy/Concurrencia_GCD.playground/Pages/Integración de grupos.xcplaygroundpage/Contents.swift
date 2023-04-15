import UIKit
import PlaygroundSupport


// MARK: - CASOS PRÁCTICOS CON GCD

// INTEGRACIÓN DE LA GESTIÓN MANUAL DE GRUPOS EN EL SISTEMA

// Vamos a probar el ciclo sin control de grupos sobre las animaciones del sistema, para luego extender el tipo UIView integrando los grupos en las animaciones, y conseguir así el control incluso de animaciones en paralelo.

extension UIView {
    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void, group: DispatchGroup, completion: ((Bool) -> Void)?) {
        group.enter()
        animate(withDuration: duration, animations: animations) { success in
            completion?(success)
            group.leave()
        }
    }
}

// Creamos una vista con fondo rojo:
let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
view.backgroundColor = .red
// Creamos una caja con fondo amarillo:
let box = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
box.backgroundColor = .yellow
// Añadimos la caja a la vista:
view.addSubview(box)

// Pintamos la vista:
PlaygroundPage.current.liveView = view

// Creamos la animación, de forma secuencial, que se mueva y rote:
//UIView.animate(withDuration: 1, animations: {
//    box.center = CGPoint(x: 150, y: 150)
//}, completion: { _ in
//    UIView.animate(withDuration: 2, animations: {
//        box.transform = CGAffineTransform(rotationAngle: .pi/2)
//    }, completion: { _ in
//        UIView.animate(withDuration: 1, animations: {
//            box.center = CGPoint(x: 50, y: 150)
//        }, completion: nil)
//    })
//})

// Veamos cómo hacer para recibir una notificación cuando termine la animación, usando los grupos y la integración del sistema.
// Lo haremos con una extensión antes del código anterior que modifique la función animate y nos pide un parámetro nuevo, que ponemos por conveniencia.
// Después de la línea 31 vendría lo siguiente (comentado el anterior para que no interfiera):
let group = DispatchGroup()
UIView.animate(withDuration: 1, animations: {
    box.center = CGPoint(x: 150, y: 150)
}, group: group, completion: { _ in
    UIView.animate(withDuration: 2, animations: {
        box.transform = CGAffineTransform(rotationAngle: .pi/2)
    }, group: group, completion: { _ in
        UIView.animate(withDuration: 1, animations: {
            box.center = CGPoint(x: 50, y: 150)
        }, group: group, completion: nil)
    })
})
// Con group podemos interpolar otras tareas y el notify nos avisa de todas porque están en group
UIView.animate(withDuration: 5, animations: {
    view.backgroundColor = .blue
}, group: group, completion: nil)

group.notify(queue: .main) {
    print("Animations complete!")
}
