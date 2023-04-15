import UIKit

var greeting = "Hello, playground"

// MARK: - INTRODUCCIÓN A LA CONCURRENCIA
/*
 
 La concurrencia es realizar varias tareas a la vez, de forma que estén organizadas y trabajen de forma óptima sin bloquear la app.
 GCD ayuda a la hora de trabajar con tareas concurrentes, ayuda a ordenarlas según preferencias o importancia, colocando cada tarea en una cola, que a su vez está en un hilo determinado.
 GCD está preparada para tareas simples y concretas, es decir, que tengan un principio y un final claros.
 Lo que hacemos es crear una tarea a través de un closure y se le pasa al despachador para que la coloque en una cola (la podemos elegir).
 
 GCD tiene dos tipos de colas: serializadas y con concurrencia. Las serializadas ejecutan las tareas en orden, una detrás de la otra; y su estructura es una cola FIFO (first-in-first-out): lo que entra primero sale primero. Estas tareas serializadas usan un mismo hilo porque van una detrás de la otra. El hilo principal, que tiene 5 colas y ejecuta la UI, es serializado.
 Las colas con concurrencia trabajan con varios hilos porque ejecutan varias tareas a la vez. Si añadimos una tarea nueva a una cola con concurrencia no se esperará a que acabe la tarea actual de esa cola, sino que se añade incluso creando un nuevo hilo si hace falta.
 
 GCD tiene 3 colas: 1.- Cola serializada de hilo principal. 2.- Cola serializada síncrona en hilo secundario. 3.- Cola concurrente asíncrona en hilos secundarios.
 Debemos evitar trabajar en el hilo principal salvo que la tarea trabaje directamente con la UI. Si colocamos una tarea pesada en el hilo principal (serializado) puede ralentizarse la interfaz y al app, porque todo lo que tenga que ver con la interfaz debe estar en el hilo principal.
 Por eso las tareas pesadas se llevan a una cola concurrente asíncrona en un hilo secundario, que puede dar una respuesta en el hilo principal cuando acabe.
    1.- Cola serializada de hilo principal (.main). Es síncrona y ejecuta las tareas una detrás de la otra. Cuenta con 5 colas, pero las tareas van en orden según acaba la anterior; las 5 colas se pueden usar para introducir tareas que tengan más prioridad.
    2.- Cola serializada síncrona en hilo secundario (.global). También funciona en modo síncrono y serializado, pero un hilo secundario para no entorpecer al hilo principal.
    3.- Cola concurrente asíncrona en hilos secundarios. Ejecuta todas las tareas a la vez de forma asíncrona y en segundo plano, creando los hilos que haga falta.
 
 */



// MARK: - CLOSURES
/*
 
 Un closure es un bloque de código, y es lo que se usa para asignar tareas en concurrencia. Son funciones anónimas, no tienen nombre y tampoco sus parámetros.
 Definen las taeas a realizar, y no tienen parámetros de entrada o salida, por lo que son tareas concretas. Aunque sí pueden usarse valores que escapan (al ámbito del propio closure).
 Si un closure usa un parámetro externo al mismo, debe capturarlo o retenerlo en memoria para poder luego ser ejecutado en cualquier momento. Ojo que esto puede crear una fuga de memoria. Porque un closure es algo que se crea para ser ejecutado en otro momento, en esencia es algo asíncrono, y por eso debe retener las variables o parámetros que use y que sean externos al mismo.
 Por tanto, si un closure captura y retiene un parámetro, ese parámetro no podrá ser borrado de memoria si lo eliminarmos, porque la copia del closure seguirá existiendo, y tendremos así una fuga de memoria. Esto se evita con los modificadores weak o unowned en el closure.
 Lo que hacen estos modificadores es, al capturar el valor dentro del closure, no sumar en el conteo automático de referencias; por lo que no hay nada que eliminar de memoria cuando se termine el ámbito y el parámetro muera y se elimine, no queda nada dentro del closure.
    WEAK, por tanto, no suma retención, y hace que self sea opcional (el parámetro capturado dentro del closure). Así, al ejecutar el closure cuando el parámetro ya no exista, no dará error porque pasará por self opcional y dará nil.
    UNOWNED tampoco suma, pero hace un desempaquetado implícito de self, por lo que sí podría dar error si el parámetro ya no existe. Ante la duda, usar siempre weak.
 Veamos un ejemplo de closure que escapa y el uso de weak y unowned:
 
 */

// Ejemplo de closure sencillo que no recibe nada y no devuelve nada:
let closure1 = { print("Hola") }

// Empleo de closure que captura un valor externo:
var x = 10
let closure2 = {
    x += 1
    print("Valor de x: \(x)")
}
closure2()
// Para poder ejecutar closure2 en cualquier momento "x" tiene que existir, por lo tanto, lo que hace es retener su valor en memoria, y sumar al conteo de referencias

// Veamos ahora una clase de ejemplo para ver la retención de memoria:
// El array es para poder guardar un closure (que capture x en su interior) fuera de la clase y ejecutarlo en cualquier otro momento
var array: [() -> ()] = []

class Test {
    var x = 10
    
    private func noEscapa(completion: () -> ()) {
        completion()
        // esta función no escapa a pesar de que captura x que está definido fuera de su ámbito, pero como solo lo usa dentro de su ámbito o contexto pues por eso se dice que no escapa
        // El parámetro completion se usa dentro de la propia función: no escapa
    }
    
    private func escapa(completion: @escaping () -> ()) {
        array.append(completion)
        // esta función hay que definirla como que escapa, porque recibe un closure que no se ejecuta en su propio ámbito, sino que en este caso se ejecuta (o almacena) fuera del propio ámbito de esta función. Y por eso se pone escaping
        // El parámetro completion se usa fuera de la propia función: escapa
    }
    
    func testSync() {
        noEscapa {
            x = 20
        }
        escapa {
            print("Hola")
            // aquí no captura nada externo así que bien
        }
        escapa {
            self.x = 15
            print(self.x)
            // aquí se captura un valor externo al closure, por lo que hay que capturar semánticamente el valor de x con self
        }
    }
}
//let test1 = Test()
//test1.x
//test1.testSync()
//test1.x
//
//array.first?() // para ejecutar el primer elemento, que es escapa con print(Hola). Recuerda que escapa hace append al array
//array.last?() // para ejecutar el último elemento, que es escapa con self.x=15
// Hasta aquí bien, se ejecutan los closures de array sin problema (código comentado para ver el ejemplo siguiente)
// Pero si creamos test1 dentro de un ámbito y ejecutamos los closures de array fuera de ese ámbito, sigue funcionando (aunque test1 no existe fuera de su ámbito) porque la función escapa a su propio ámbito

do {
    let test1 = Test()
    test1.x
    test1.testSync()
    test1.x
}
//aquí ya no existe test1
array.first?()
array.last?()
// Tenemos aquí una fuga de memoria porque, al ir a borrar x, ya no podemos porque test1, que lo creó, ya no existe
// Esto se soluciona con el modificador weak, que además convierte a self en opcional:
class Test2 {
    var x = 10
    
    private func noEscapa(completion: () -> ()) {
        completion()
    }
    
    private func escapa(completion: @escaping () -> ()) {
        array.append(completion)
    }
    
    func testSync() {
        noEscapa {
            x = 20
        }
        escapa {
            print("Hola")
        }
        escapa { [weak self] in
            self?.x = 15
            print(self?.x ?? 0)
        }
    }
}
// En este caso, si hacemos el ejercicio de antes de usar el do{}, array.last imprime 0 y no 15 porque test1 ya no existiría, y el opcional de self se va por el operador de coalescencia nula.
// Pero sí imprime Hola porque ese closure no captura nada, no crea nada en memoria

