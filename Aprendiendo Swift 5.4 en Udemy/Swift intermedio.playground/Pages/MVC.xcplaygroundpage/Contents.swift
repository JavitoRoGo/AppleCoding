import UIKit

// MODELO VISTA CONTROLADOR
// DELEGACIONES EN PROCESOS ASÍNCRONOS
// Ejemplo con un reproductor de sonidos, que actúa en la propia clase cuando acaba de reproducir y nos permite actuar en consecuencia
import AVFoundation
class reproductor: NSObject, AVAudioPlayerDelegate {
    var play = false
    var player = AVAudioPlayer()
    
    func reproduce(audio: String) {
        guard let path = Bundle.main.path(forResource: audio, ofType: "mp3") else { return }
        //esto busca en el directorio principal de recursos el archivo que se llama audio y con extensión mp3, y nos da el path
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            //inicializa el reproductor player
            player.delegate = self //esto hace que la clase AVAudioPlayer, cuando termine de reproducir y llame a audioPlayerDidFinishPlaying, lo haga en mi clase (self) y no en la propia AVAudioPlayer
            player.play()
            play = true //comenzamos la reproducción
        } catch {
            fatalError("Error en la reproducción")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //esta función nos dice cuándo ha terminado de reproducir, es la delegación
        play = false
        print("Se acabó la reproducción")
    }
}
let player = reproductor()
player.reproduce(audio: "algo") //así haríamos que reproduzca un archivo, y al final ejecutaría el print


// CREAR UNA DELEGACIÓN
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//las dos líneas anteriores son para que el playground se siga ejecutando una vez que compile

protocol Delegacion {
    func finalDelegado(clase: miClase)
}
class miClase {
    var delegate: Delegacion?
    
    func accion() {
        let _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.finAccion), userInfo: nil, repeats: false)
        //a los 5 segundos llama a finAccion, que a su vez llama a finalDelegado del protocolo
    }
    @objc func finAccion() {
        //queremos que cuando termine la accion anterior de esta clase, se llame al finalDelegado
        delegate?.finalDelegado(clase: self)
    }
}

class claseQueUsaAccion: Delegacion {
    func activaAccion() {
        let clase = miClase()
        clase.delegate = self //esto hace que miClase sea claseQueUsaAccion, y así llamar a finalDelegado
        clase.accion()
    }
    func finalDelegado(clase: miClase) {
        print("Se acabó la acción ejecutada")
        clase.delegate = nil //para romper la delegación que hemos creado
    }
}
let test = claseQueUsaAccion()
test.activaAccion()
