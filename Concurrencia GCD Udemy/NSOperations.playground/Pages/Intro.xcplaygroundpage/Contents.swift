import UIKit

var greeting = "Hello, playground"

/*
 Las operaciones heredan de NSObject y nos permiten crear tareas que podemos controlar. Una operación es como una tarea.
 Se usa la clase BlockOperation, y sus objetos funcionan como colas concurrentes, pudiendo tener tantos bloques como queramos. También hay un bloque de completado que se ejecutaría cuando terminen todos los bloques.
 Las operaciones son síncronas, se ejecutan en el hilo que estemos, pero todas a la vez de forma concurrente e invocando nuevos hilos según haga falta.
 Para crear una operación asíncrona hay que crear una subclase de Operation.
 Las BlockOperation se ejecutan de forma concurrente (todas a la vez), pero podemos limitar el número máximo de operaciones concurrentes. Si lo limitamos a 1, entonces tendremos operaciones serializadas. En cualquier caso, se ejecutarán en el orden que el sistema quiera, y no en el orden que las hayamos puesto en la cola.
 
 
 COLAS DE OPERACIONES
 
 Las operaciones pueden agruparse en colas, y las colas pueden tener su valor de qos y valor máximo permitido de operaciones.
 Las operaciones son síncronas. No obstante, crando un hijo de Operation se pueden adaptar y podemos gestionar la asincronía o estados de forma manual.
 */
