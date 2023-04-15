import Foundation

// Para poder suscribirnos a las notificaciones al terminar un bloque podemos hacerlo usando un bloque de completado como en un ejemplo anterior; pero también se puede usar el patrón KVO o key value observed, que nos avisa al cambiar un valor

class Operaciones: NSObject {
    let block1 = BlockOperation {
        let tiempo = UInt32.random(in: 1...3)
        print("Cargando 1")
        sleep(tiempo)
        print("1 cargado en \(tiempo) segundos")
    }
    @objc let block2 = BlockOperation {
        let tiempo = UInt32.random(in: 1...3)
        print("Cargando 2")
        sleep(tiempo)
        print("2 cargado en \(tiempo) segundos")
    }
    let block3 = BlockOperation {
        let tiempo = UInt32.random(in: 1...3)
        print("Cargando 3")
        sleep(tiempo)
        print("3 cargado en \(tiempo) segundos")
    }
    
    let queue = OperationQueue()
    var observation: NSKeyValueObservation?
    
    func start() {
        observation = block2.observe(\.isFinished, changeHandler: { object, change in
            print("Terminó la tarea 2")
        })
        queue.addOperations([block1, block2, block3], waitUntilFinished: true)
    }
}

let operacion = Operaciones()
operacion.start()
print("Se acabó")
