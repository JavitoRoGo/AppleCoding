import Foundation


// MARK: - FUNCIONAMIENTO DE GCD

/*
 GCD facilita la gestión de hilos y tareas, basado en una estructura de colas. Esta gestión la hace GCD de forma automática aunque nosotros podemos darle algunas indicaciones.
 Las colas se invocan a través de singletons (inicializadores) de la clase DispatchQueue.
 La cola principal es serializada, cuenta con 5 colas que introducen tareas en el hilo principal con prioridad FIFO, y se invoca con .main.
 Cada tarea en una cola es un objeto DispatchWorkItem, y se pueden agrupar varios en DispatchGroup.
 Las tareas se pueden enviar a una cola de forma asíncrona con async; de forma asíncrona tras pasar un tiempo con asyncAfter; programada para un momento dado con schedule; o de forma síncrona con sync.
 */



// MARK: - QUALITY OF SERVICE

/*
 Es un sistema que establece la prioridad de una tarea al introducirse en una cola con GCD. La cola principal ya tiene de por sí el nivel de prioridad más alto, pero en la cola global podemos indicarle el nivel de QoS. Los niveles son:
    .userInteractive: indica que la tarea tiene que ver con una interacción del usuario, por lo que le da la mayor prioridad. Indica que se operará con (pero NO en) el hilo principal para refrescar la UI.
    .userInitiated: indica que la tarea ha sido iniciada por el usuario y requiere una respuesta rápida, pero en este caso no se va a actulizar la UI. El usuario está esperando a que la tarea termine y por eso la respuesta debe ser rápida, pero al no actualizar la interfaz no tiene tanta prioridad como la anterior.
    .utility: indica que la tarea tardará un tiempo indeterminado y no requiere un resultado inmediato, el usuario no recibe información al respecto. Algo que hay que hacer y listo, y ya acabará.
    .background: indica que la tarea se realiza completamente en segundo plano y el usuario no tendrá feedback de la misma. Es la de menor prioridad.
    .default: está entre .userInitiated y .utility y es la que coge el sistema por defecto en caso que no le indiquemos nada.
    .unspecified: representa la ausencia de un valor qos, y se usaría sobretodo por retrocompatibilidad con sistemas antiguos o APIs obsoletas cuyos hilos no soporten el concepto qos.
 */



// MARK: - CREAR COLAS E INTRODUCIR TAREAS

DispatchQueue.main.async {
    print("Hola main")
    // así tenemos ya una tarea en el hilo principal, cuya cola es serializada
}

DispatchQueue.global().async {
    print("Hola global")
    // así tenemos una tarea en la cola global, cola concurrente
}
// En cualquiera de los dos casos tenemos 4 métodos para introducir las tareas: .async, .asyncAfter, .schedule, y .sync

// Para dar un valor de qos sería:
DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 5, execute: {
    print("Hola qos")
})

// Podemos crear nuestro propio dispatch: el primer caso es una cola serializada, y el segundo es una cola concurrente
let dispatch = DispatchQueue(label: "com.applecoding.serial") //se puede usar cualquier nombre pero se suele usar el bundle ID y añadir .serial
let dispatchC = DispatchQueue(label: "com.applecoding.concurrent", qos: .userInteractive, attributes: .concurrent)
dispatchC.schedule(after: .init(.now() + 86400), tolerance: .seconds(1)) {
    print("Acción programada para mañana")
}

// También hay una opción de crear tareas en bucle, como una especie de bucle for-in:
DispatchQueue.concurrentPerform(iterations: 10) { index in
    print("Iteración \(index)")
}



// MARK: - GRUPOS DE DESPACHADO

// Permite agrupar varias tareas a la vez y pasarlas a una cola, por ejemplo, para mostrar una notificación cuando todas ellas terminen
let group = DispatchGroup()

DispatchQueue.global().async(group: group) {
    print("Tarea de ejecución")
    // ya tenemos un grupo de tareas creado, en este caso en hilo secundario
}
// Si queremos añadir una tarea a este grupo se haría:
group.enter()
print("Hola Grupo 1")
group.leave()

// Podemos pedirle un aviso para cuando termine un grupo:
group.notify(queue: .main) {
    print("Tareas terminadas")
}



// MARK: - ITEMS DE TRABAJO

// Dispatch work items: son formas de introducir los closures en las colas, de forma que se almacenen y no se ejecuten justo al introducirlos

let dispatch2 = DispatchQueue(label: "com.applecoding.concurret", qos: .userInteractive, attributes: .concurrent)
let dispatchSerial = DispatchQueue(label: "com.applecoding.serial")

let item1 = DispatchWorkItem {
    print("Hola 1")
    // es un elemento de trabajo en una cola pero no se ejecuta, sirve para guardarla y ejecutarla luego cuando nos interese
}
// También se pueden anidar
let item2 = DispatchWorkItem {
    print("Hola 2")
    dispatch2.async(execute: item1)
}
// Para que se ejecute un item tenemos que añadirlo a una cola:
dispatchSerial.async(execute: item2) //el item2 lo ejecuta en la cola serializada, pero el item1 (dentro de item2) lo ejecuta en la cola asíncrona

// Podemos crear un item con valor de qos
let item3 = DispatchWorkItem(qos: .userInitiated, flags: .inheritQoS) {
    print("Hola 3")
}
dispatchSerial.async(execute: item3)



// MARK: - PARANDO Y ESPERANDO

// Veamos cómo crear varias tareas asíncronas, parar su hilo de ejecución y que esperen a que otra termine, y hacer que acaben todas a la vez con grupos

let queue = DispatchQueue.global(qos: .userInteractive)
let group2 = DispatchGroup()

/*
for i in 1...6 {
    // creamos 6 tareas concurrentes que se paren o duerman un tiempo determinado
    // todas entran a la cola a la vez por ser concurrente, y terminan cuando pasa el tiempo establecido
    queue.async {
        let tiempo = UInt32.random(in: 2...7)
        print("Iniciada tarea \(i) en \(tiempo) segundos")
        sleep(tiempo)
        print("Tarea \(i) finalizada")
    }
}
 */

// Ahora hacemos lo mismo que antes (comentado) pero haciendo que las tareas entren al grupo:
for i in 1...6 {
    queue.async(group: group2) {
        let tiempo = UInt32.random(in: 2...7)
        print("Iniciada tarea \(i) en \(tiempo) segundos")
        sleep(tiempo)
        print("Tarea \(i) finalizada")
    }
}
// Lo que podemos hacer con el grupo es lo siguiente: decirle a la ejecución que se pare hasta que termine el grupo, y luego que siga con lo que haya:
group2.wait()
print("Hola estoy aquí")
// Esto se puede hacer porque estamos en un hilo secundario; en el principal no podemos porque es serializado y pararíamos la app, se quedaría congelada.
// Un ejemplo de aplicación práctica sería cargar una serie de imágenes o datos en segundo plano, y enviar una señal cuando esté todo listo para que la app se cargue o siga su ejecución
// Podemos incluso dar un tiempo para que no esté esperando eternamente
group2.wait(timeout: .now() + .seconds(5))



// MARK: - COLA SERIALIZADA VS COLA CONCURRENTE

/*
 Por aclarar conceptos:
 Una cola serializada ejecuta las tareas una después de la otra, la 2 empieza cuando termina la 1.
 Una cola concurrente ejecuta todas las tareas a la vez en varios hilos según los necesite.
 Ambas colas pueden ser síncronas o asíncronas.
 
 Una tarea síncrona es la que se ejecuta en el mismo sitio o solo dentro del hilo. No depende de parámetros externos.
 Una tarea asíncrona es la que se ejecuta fuera, o tiene que esperar por una respuesta de fuera, como puede ser una llamada de red.
 */

// Vamos a ver el funcionamiento de una cola serializada, otra concurrente, y compararlas.
let serialQueue = DispatchQueue(label: "com.queue.serial")
serialQueue.async {
    print("Comienzo tarea 1")
    sleep(2)
    print("Finalizó tarea 1")
}
serialQueue.async {
    print("Comienzo tarea 2")
    sleep(2)
    print("Finalizó tarea 2")
}
serialQueue.async {
    print("Comienzo tarea 3")
    sleep(2)
    print("Finalizó tarea 3")
}

let concurrentQueue = DispatchQueue(label: "com.queue.concurrent", attributes: .concurrent)
concurrentQueue.async {
    print("Comienzo tarea concurrente 1")
    sleep(2)
    print("Finalizó tarea concurrente 1")
}
concurrentQueue.async {
    print("Comienzo tarea concurrente 2")
    sleep(2)
    print("Finalizó tarea concurrente 2")
}
concurrentQueue.async {
    print("Comienzo tarea concurrente 3")
    sleep(2)
    print("Finalizó tarea concurrente 3")
}



// MARK: - TAREAS BARRERA EN COLAS CONCURRENTES

// Una barrera nos permite trabajar con una cola concurrente como si fuera serializada, y sacar lo mejor de los dos mundos.
// Por ejemplo, creamos los items 1, 2, 4 y 5 que se ejecutan todos a la vez en una cola concurrente, y un item 3 de tipo barrera que serializa la cola concurrente, haciendo que 4 y 5 no se ejecuten hasta que termine el 3.

let group3 = DispatchGroup()
let workQueue = DispatchQueue(label: "com.queue.concurrent", attributes: .concurrent)
func caso1() {
    print("Comienzo tarea 1 concurrente")
    sleep(3)
    print("Fin tarea 1 concurrente")
}
func caso2() {
    print("Comienzo tarea 2 concurrente")
    sleep(3)
    print("Fin tarea 2 concurrente")
}

func caso3Barrera() {
    print("Comienzo tarea 3 concurrente (barrera)")
    sleep(3)
    print("Fin tarea 3 concurrente (barrera)")
}

func caso4() {
    print("Comienzo tarea 4 concurrente")
    sleep(3)
    print("Fin tarea 4 concurrente")
}
func caso5() {
    print("Comienzo tarea 5 concurrente")
    sleep(3)
    print("Fin tarea 5 concurrente")
}

let workItem1 = DispatchWorkItem(block: caso1)
let workItem2 = DispatchWorkItem(block: caso2)
let workItem3Barrera = DispatchWorkItem(qos: .utility, flags: .barrier, block: caso3Barrera)
let workItem4 = DispatchWorkItem(block: caso4)
let workItem5 = DispatchWorkItem(block: caso5)

workQueue.async(group: group3, execute: workItem1)
workQueue.async(group: group3, execute: workItem2)
workQueue.async(group: group3, execute: workItem3Barrera)
workQueue.async(group: group3, execute: workItem4)
workQueue.async(group: group3, execute: workItem5)

group3.notify(queue: .main) {
    print("Todo OK")
}
