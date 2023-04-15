import Foundation


let blockOperation = BlockOperation {
    print("Hago cosas")
}

// Antes vimos .start para ejecutar el bloque; pero también puede ejecutarse añadiéndolo a una cola:
let queue = OperationQueue() // es una cola concurrente
queue.addOperation(blockOperation)
queue.addOperation {
    print("Hago más cosas")
}
// Se lanza en el momento que se añade a la cola

// Y si añadimos varios bloques sería:
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
multiPrinter.addExecutionBlock {
    sleep(2)
    print("concurres")
}
multiPrinter.addExecutionBlock {
    sleep(4)
    print("o k ases")
}

let queue2 = OperationQueue()
queue2.addOperation(multiPrinter)

// Otra cosa que puede hacerse es añadirles bloques de completado, otro closure que se ejecuta al final del bloque, cuando todas las operaciones del bloque se hayan ejecutado
multiPrinter.completionBlock = {
    print("Se acabó")
}
