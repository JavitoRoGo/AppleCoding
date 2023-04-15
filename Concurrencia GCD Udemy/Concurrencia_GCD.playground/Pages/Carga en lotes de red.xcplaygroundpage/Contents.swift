import UIKit


// MARK: - CASOS PRÁCTICOS CON GCD

// DESCARGA EN LOTES DE RED

// Lo que haremos en este ejemplo es descargar un lote de imágenes con una llamada de red y con GCD, de forma que las imágenes se descargan de forma serializada y se añaden a un grupo, al que le diremos que se espere hasta que estén todas pra luego seguir con el código

let urlImages = ["https://applecoding.com/wp-content/uploads/2019/07/cropped-black-and-white-black-and-white-challenge-262488-1024x576.jpg",
                 "https://applecoding.com/wp-content/uploads/2019/07/cropped-company-concept-creative-7369-1-1024x575.jpg",
                 "https://applecoding.com/wp-content/uploads/2018/06/cropped-mapkitjs-portada-1024x576.jpg",
                 "https://applecoding.com/wp-content/uploads/2019/06/combine-operators-1024x573-1024x576.jpg",
                 "https://applecoding.com/wp-content/uploads/2019/06/wwdc_2_0.jpg",
                 "https://applecoding.com/wp-content/uploads/2018/06/header-390x220.jpg",
                 "https://applecoding.com/wp-content/uploads/2018/06/mapkitjs-portada-1024x576.jpg"]

//Función para descarga de imágenes de la red. Tiene dos parámetros, uno de los cuales es un closure que escapa al ámbito de la función
func downloadImage(url: URL, completionImage: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            if let error = error {
                print("Error en la operación \(error)")
            }
            return
        }
        if response.statusCode == 200 { // todo ha ido bien
            if let image = UIImage(data: data) { // obtención de imagen desde data
                completionImage(image)
            } else {
                print("No es una imagen")
            }
        } else {
            print("Error \(response.statusCode)")
        }
    }.resume() // para que termine de ejecutar todo
}

var resultado: [UIImage] = []

// Cola de despachado serializada y asíncrona (se ejecuta cuando pueda).
// Incluye la creación de un grupo para poder controlar cuando terminan todas las descargas y ejecutar un código que nos avise o haga algo concreto (mostrar el resultado en este ejemplo):
DispatchQueue(label: "com.queue.serial").async {
    let downloadGroup = DispatchGroup()
    
    urlImages.forEach {
        if let url = URL(string: $0) {
            downloadGroup.enter() // añadir o ejecutar en el grupo
            downloadImage(url: url) { // descarga la imagen
                resultado.append($0)
                downloadGroup.leave() // salir del grupo
            }
        }
    }
    
    // como estamos en un hilo secundario podemos parar el código para que espere hasta que termine el grupo, y luego seguir ejecutando el resto, y obtener así todas la imágenes:
    downloadGroup.wait()
    
    DispatchQueue.main.async {
        // con esto metemos el resultado en el hilo principal, y en cuanto pueda con .async
        print(resultado)
        resultado
    }
}

// Usando el grupo y el .wait nos ahorramos un montón de follón con llamadas recursivas y uso de NSNotification y podemos tener el mismo resultado; a saber, que el código se pare y espere a que terminen todas las llamadas de red para seguir.
// Como ya vimos, podemos incluso usar un timeOut para darle un tiempo máximo por si alguna llamada falla o se cuelga, y así dar el proceso por finalizado y que no se eternice.
