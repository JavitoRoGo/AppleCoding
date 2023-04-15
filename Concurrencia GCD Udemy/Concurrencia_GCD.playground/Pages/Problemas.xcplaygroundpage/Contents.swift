import Foundation

// MARK: - LOS PROBLEMAS DE LA CONCURRENCIA

/*
 Hay 3 problemas principales con la concurrencia:
 1. Race conditions: cuando dos tareas tratan de acceder a la vez al mismo dato, creando un problema de desincronía
 2. Inversión de prioridad: el bloqueo que creamos para evitar el race condition puede hacer que una tarea de menor prioridad se ejecute antes que otra de mayor prioridad
 3. Deadlock o bloqueo mortal: dos tareas intentan acceder al mismo dato, pero una tarea bloquea el dato que necesita la otra, y la otra bloquea el dato que necesita la una. Ninguna liberará el bloqueo del dato, y la app se bloqueará.
 Los dos primeros los evita GCD automáticamente, y el tercero se evita con buenas prácticas en su uso.
 */


// MARK: - RACE CONDITION

/*
 Tareas concurrentes que se ejecutan a la vez e intentan acceder al mismo dato de forma simultánea; en una cola serializada nunca ocurre.
 Esto depende de los tiempos de la CPU y del momento de inicio de una tarea, por lo que son problemas tremendamente aleatorios y difíciles de detectar y depurar.
 GCD soluciona esto de forma automática a través del uso de colas y del bloqueo de recursos de los elementos que están en las colas: las colas de GCD impiden que un mismo dato sea demandado a la vez por dos procesos en dos tareas distintas.
 */



// MARK: - INVERSIÓN DE PRIORIDAD

/*
 Se puede dar como consecuencia del bloque de recursos de la solución anteior, y tiene como consecuencia que una tarea de prioridad más baja se ejecute antes que otra de mayor prioridad; precisamente porque la tarea menos prioritaria tiene el recurso bloqueado, y la de mayor prioridad tiene que esperar a que la otra tarea termine y lo desbloquee.
 GCD previene contra este problema de la siguiente forma: aumenta la prioridad de la tarea que bloquea el recurso para que se ejecute en primer lugar y pueda liberar el dato, y así ya se podría ejecutar la otra tarea de mayor prioridad.
 También en este caso lo hace GCD de forma automática.
 */



// MARK: - DEADLOCK

/*
 Es el mayor problema de la concurrencia y solo se resuelve mediante las buenas prácticas de programación. Obviamente, en colas serializadas no ocurre.
 Se produce cuando dos hilos necesitan un recurso que tiene bloqueado el otro, que no será liberado hasta que liberen aquello que no pueden: uno depende del otro, y el otro del uno. No hay solución.
 Esto se puede prevenir con el buen uso de QoS (quality of service), definiendo de forma correcta la prioridad de las tareas que se van introduciendo en las colas.
 También podemos cancelar uno de los dos hilos que provocan el bloqueo.
 */

