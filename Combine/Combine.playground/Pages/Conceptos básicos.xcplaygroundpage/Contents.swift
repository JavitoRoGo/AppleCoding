import Combine
import UIKit

// CONCEPTOS BÁSICOS

/*
 Combine es la librería cerrada propia de Swift para trabajar en asincronía de forma declarativa, es una API de asincronía declarativa que gestiona llamadas en el tiempo, aunque la forma más reciente de hacerlo es con async-await. Pero de momento veamos combine, que funciona con UIKit pero se creó para trabajar con SwiftUI
 Se compone de tres elementos
    - Publicador, es el responsable de lanzar una señal cuando ocurre uno de los eventos en el tiempo
    - Suscriptor, es el que escucha, el que está pendiente del publicador y reacciona
    - Operador, el que permite transformar y operar con la señal del publicador, de forma que se procese y llegue al suscriptor en la forma que nos interese. Por tanto, estaría entre el publisher y el subscriber
 
 El ciclo de vida de Combine empieza programando un publicador con un emisor, emisor que emitirá señales cada vez que haya un cambio en el publicador.
 Luego el suscriptor se suscribe a esas señales y las procesa cuando son recibidas, con un valor de éxito y otro de error.
 Y entre los dos se coloca el operador, que puede transformar o trabajar con el resultado o error emitido. Y todo de forma declarativa.
 
 Como el éxito y el error van juntos, no se emite un tipo de dato como string o data o así, sino que se usa el tipo resultado: Result<T, E>. Es un genérico que contiene el valor cuando la operación es correcta y el posible error: es el tipo de Schrodinger, no sabemos lo qué es hasta que lo abramos. El tipo T es el que nos interese en cada caso, y el error es un enum conformado al tipo Error.
 
 Siempre se tienen las dos posibilidades (éxito y error), por lo que hemos de tratar el dato con algún flujo que permita discernir si ha habido un éxito o un error. Para ello, podemos usar un switch o if case.
*/


// FUTUROS Y PROMESAS

/*
 Un futuro es un tipo de resultado asíncrono, es un publicador de un solo uso que deja de emitir cuando se termina.
 Un futuro permite devolver un resultado desde una función síncrona que tenga una llamada asíncrona aunque el dato no exista, porque es un futuro dato. Por ejemplo, una función asíncrona que devuelva una imagen leída de la red devolverá un valor futuro de UIImage.
 Si devolvemos un futuro, un elemento esencial nos permitirá devolver el resultado y procesarlo de forma asíncrona mediante suscriptores en Combine: la promesa. De tal forma que sí podemos devolver un valor de una función, porque lo que se devuelve es un tipo Result pero futuro. Por ejemplo:
 */
func cargarImagen(url: URL) -> Future<UIImage, URLError> {
    Future<UIImage, URLError> { promesa in
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Recibo el dato y devuelvo el resultado
            promesa(.success(UIImage()))
        }
    }
}
/*
 Por tanto, una promesa es quien realiza la emisión cuando un publicador emite un resultado; es la promesa de un resultado (correcto o erróneo).
 Es como crear un tipo de dato Result, pero de forma asíncrona, permitiendo resolver un futuro y que el suscriptor reciba la respuesta.
 El publicador avisa del cambio o de un suceso, la promesa emite la señal o el futuro del resultado, y el suscriptor recibe esa señal o futuro resultado.
 */


//: [Next](@next)
