//: [Previous](@previous)

// CICLO DE VIDA
// PUBLICADORES, OPERADORES Y SUSCRIPTORES

/*
 Un publicador es un emisor que envía señales cuando ocurre un evento determinado, es la promesa que emite la señal: es un array de futuros.
 Como el publicador se mueve fuera de la línea de ejecución normal de la app, las señales que emite serán enviadas a través de un canal de transmisión o stream. Lo que se emite puede transformarse por un operador antes de ser escuchado por el suscriptor.
 */

/*
 El segundo elemento es el suscriptor, que es un elemento que escucha cualquier señal emitida por un publicador. Recibe por tanto el dato Result, y actúa según sea success o failure.
 Por tanto, está al final de la línea de transmisión y es quién decide qué hacer en función del result.
 La instancia del suscriptor la devuelve o genera el propio publicador; el suscriptor va a contener la referencia del publicador en su interior, por lo que si retenemos en memoria al suscriptor, también estaremos reteniendo al publicador.
 Se puede cancelar el suscriptor o hacer que deje de escuchar aunque el publicador siga emitiendo.
 */

/*
 El tercer elemento es el operador, que permite transformar el contenido que hay en el stream antes de que llegue al suscriptor.
 Puede transformar el contenido tanto si es un success como si es failure. Y es más, incluso puede transformar un success en failure si no nos sirven los datos; y hasta transformar el propio publicador en otro distinto.
 Son funciones de orden más alto como map, filter, flatmap, try, throw, etc.
 */

/*
 El ciclo de vida de Combine sería de la siguiente forma:
 - Se crea el publicador y su instancia.
 - El publicador crea la instancia del suscriptor.
 - El suscriptor solicita la info al publicador y se conecta a su stream.
 - Entran en funcionamiento los operadores para transformar la info del stream.
 - Al terminar los operadores, se envía la señal del publicador al suscriptor.
 - Si el publicador termina y no va a emitir más, emite también la señal de completado, terminando así también el suscriptor.
 */


//: [Next](@next)
