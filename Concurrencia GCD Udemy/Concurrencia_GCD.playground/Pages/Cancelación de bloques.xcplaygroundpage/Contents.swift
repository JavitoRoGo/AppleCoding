import UIKit


// MARK: - CASOS PRÁCTICOS CON GCD

// CANCELACIÓN DE BLOQUES

// Una vez que la tarea entra en la cola ya no se puede cancelar, así que habría que retrasar su entrada en la cola y luego decidir si cancelar o no.

let urlImages = [
    "https://applecoding.com/wp-content/uploads/2019/07/cropped-black-and-white-black-and-white-challenge-262488-1024x576.jpg",
    "https://applecoding.com/wp-content/uploads/2019/07/cropped-company-concept-creative-7369-1-1024x575.jpg",
    "https://applecoding.com/wp-content/uploads/2018/06/cropped-mapkitjs-portada-1024x576.jpg",
    "https://applecoding.com/wp-content/uploads/2019/06/combine-operators-1024x573-1024x576.jpg",
    "https://applecoding.com/wp-content/uploads/2019/06/wwdc_2_0.jpg",
    "https://applecoding.com/wp-content/uploads/2018/06/header-390x220.jpg",
    "https://applecoding.com/wp-content/uploads/2018/06/mapkitjs-portada-1024x576.jpg"]

func downloadImage(url: URL, completionImage: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            if let error = error {
                print("Error en la operación \(error)")
            }
            return
        }
        if response.statusCode == 200 {
            if let image = UIImage(data: data) {
                completionImage(image)
            } else {
                print("No es una imagen")
            }
        } else {
            print("Error \(response.statusCode)")
        }
    }.resume()
}

let downloadGroup = DispatchGroup()
var resultado: [UIImage] = []
var blocks: [DispatchWorkItem] = []

for address in urlImages {
    let tiempo = Double.random(in: 1...4)
    let block = DispatchWorkItem {
        let url = URL(string: address)!
        downloadGroup.enter()
        downloadImage(url: url) { image in
            sleep(UInt32(tiempo))
            resultado.append(image)
            downloadGroup.leave()
            print("Recuperada imagen \(url.path)")
        }
    }
    blocks.append(block)
    print("URL \(address) retenida \(tiempo) segundos.")
    DispatchQueue.global(qos: .userInteractive).async(execute: block)
    
    print(resultado)
    resultado
}

DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 3) {
    blocks.forEach {
        $0.cancel()
        // con esto conseguimos que las tareas se cancelen una vez que pasen 3 segundos, pero no pasa nada, no se cancelan, porque ya han entrado todas en la cola
    }
}
