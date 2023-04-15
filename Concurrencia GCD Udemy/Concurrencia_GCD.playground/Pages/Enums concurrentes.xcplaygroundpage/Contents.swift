import UIKit



// MARK: - CASOS PRÁCTICOS CON GCD

// ENUMERACIONES CONCURRENTES

// Vamos a recuperar un número indeterminado de imágenes cargando un json de red, haremos una operación concurrente incluyendo el grupo de despachado y notificación.

struct Images: Codable {
    let images: [URL]
}

let urlJson = URL(string: "https://applecodingacademy.com/testData/testImages.json")!

func downloadImage(url: URL, completion: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            if let error = error {
                print("Error en la operación: \(error)")
            }
            return
        }
        if response.statusCode == 200 {
            if let imagen = UIImage(data: data) {
                completion(imagen)
            } else {
                print("No es una imagen")
            }
        } else {
            print("Error \(response.statusCode)")
        }
    }.resume()
}

var images: Images?
var resultado = [UIImage?]() // lo hacemos opcional porque UIImage(data:) devuelve opcionales

let downloadGroup = DispatchGroup()
let _ = DispatchQueue.global(qos: .userInitiated) // esta inicialización a vacío lo que hace es preparar la cola global que usemos después con el qos que le hemos dicho

// Recuperar el json pero de forma más rápida para el ejemplo, sin gestionar los errores sino directo con try?:
URLSession.shared.dataTask(with: urlJson) { data, _, _ in
    guard let data = data else { return }
    images = try? JSONDecoder().decode(Images.self, from: data)
    
    if let images = images {
        // precargamos el array resultado con nil y en número igual a las imágenes recuperadas, para que así se carguen las imágenes y se asignen en el mismo orden que el array original:
        resultado = [UIImage?](repeating: nil, count: images.images.count)
        DispatchQueue.concurrentPerform(iterations: images.images.count) { index in
            downloadGroup.enter()
            downloadImage(url: images.images[index]) { image in
                resultado[index] = image
                downloadGroup.leave()
            }
        }
    }
    
    downloadGroup.notify(queue: .main) {
        let imagesLoad = resultado.compactMap { $0 } // para quitar los nils y opcionales
        imagesLoad
    }
}.resume()
