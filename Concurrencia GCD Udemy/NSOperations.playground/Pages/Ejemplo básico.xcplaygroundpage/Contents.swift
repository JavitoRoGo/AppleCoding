import Foundation


let operation1 = BlockOperation {
    print("Operación 1 iniciada")
    sleep(2)
    print("Operación 1 finalizada")
}
// Esta es la unidad básica de trabajo con operaciones, un closure que no recibe nada y no devuelve nada. Pero para ejecutarlo hay que lanzarlo: con start se ejecuta sin necesidad de ponerlo en una cola, y se ejecuta en el hilo en el que esté en ese momento:
operation1.start()

// Hagamos una prueba: crear un bloque pero vacío, que tiene la capacidad de recibir luego las operaciones que queramos y funcionar como una especie de cola.
let multiPrinter = BlockOperation()
multiPrinter.addExecutionBlock {
    sleep(2)
    print("Ola")
}
multiPrinter.addExecutionBlock {
    sleep(2)
    print("k")
}
multiPrinter.addExecutionBlock {
    sleep(2)
    print("ase")
}
multiPrinter.start()
// Vemos que se ejectuan las 3 operaciones a la vez y en el orden que le da la gana, porque los bloques siempre son concurrentes
