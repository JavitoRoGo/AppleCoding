import Foundation

// Las operaciones siempre funcionan de forma concurrente, nunca de forma serializada. Peeeero, se puede engañar al sistema y simular ese comportamiento.
let printerQueue = OperationQueue()

printerQueue.addOperation {
    sleep(1)
    print("Hola")
}
printerQueue.addOperation {
    sleep(3)
    print("holita")
}
printerQueue.addOperation {
    sleep(3)
    print("adiós")
}

// Una forma de hacerlo es haciendo que las operaciones entren de una en una, poniendo la siguiente línea después de let, y la otra líena al final de todo:
printerQueue.maxConcurrentOperationCount = 1
printerQueue.waitUntilAllOperationsAreFinished()

// Otra opción es usar los bloques barrera: lo que ocurre es que entraría en la cola todo a la vez (lo normal), se pararía la ejecución al llegar al bloque barrera y hasta que termine, y luego seguiría con el resto
// El bloque barrera sería:
printerQueue.addBarrierBlock {
    sleep(3)
    print("bloque barrera")
}
