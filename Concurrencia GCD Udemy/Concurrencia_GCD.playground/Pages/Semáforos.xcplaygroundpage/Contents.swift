import Foundation


// MARK: - CASOS PRÁCTICOS CON GCD

// SEMÁFOROS

// Sirven para limitar el número de tareas concurrentes, y sobre todo para evitar condiciones de carrera porque evitan que se acceda a un recurso de forma simultánea por más de una tarea.
// Limitan el número de tareas concurrentes que se ejecutan a la vez, y el máximo lo fijamos nosotros.

let queue = DispatchQueue(label: "com.queue.concurrent", qos: .userInteractive, attributes: .concurrent)
let group = DispatchGroup()

let semaphore = DispatchSemaphore(value: 4)

for i in 1...10 {
    queue.async {
        semaphore.wait() // esto resta 1 al valor del semáforo cada vez que ejecuta la tarea, y al llegar a 0 se para hasta que vuelva a tener espacio libre y sea >0
        
        print("Process number \(i)")
        sleep(UInt32.random(in: 2...4))
        print("Process finished \(i)")
        
        semaphore.signal() // esto devuelve un entero y envía la señal al semáforo que ya terminamos, lo pone en verde
    }
}
// Si el valor del semáforo es 1 tendríamos un acceso exclusivo al recurso, y convertiría la cola concurrente en serializada


// Vamos a ver otro ejemplo:
class Resource {
    var cadena: String
    
    init(cadena: String) {
        self.cadena = cadena
    }
}
let resource1 = Resource(cadena: "0")

let semaphore1 = DispatchSemaphore(value: 1)

for i in 1...10 {
    queue.async(group: group) {
        semaphore1.wait()
        
        print("Process number \(i)")
        sleep(UInt32.random(in: 2...4))
        resource1.cadena.append("\(i)") // accedemos de forma continua al mismo recurso para añadir el número, pero el sleep random da tiempos diferentes, y lo que queremos son los números en orden
        // Tenemos que bloquear el recurso para que quede en orden
        print("Finish number \(i)")
        
        semaphore1.signal()
    }
}
group.wait()
print(resource1.cadena)
