import CoreImage.CIFilterBuiltins
import UIKit

// Las dependencias nos permiten coger el resultado de una operación e inyectarlo en otra operación, de forma que se ejecute como si fuera una sola operación en conjunto.
// Esto puede hacerse al crear nuestra propia subclase, porque en este caso sí permite tener parámetros de entrada a través de las propiedades de la propia subclase, y así inyectar la instancia de la operación anterior en la siguiente
// Lo que haremos en este ejemplo es descargar una imagen y pasarle el filtro de blanco y negro

let images = ["https://applecoding.com/wp-content/uploads/2019/06/combine-operators-1024x573-1024x576.jpg",
              "https://applecoding.com/wp-content/uploads/2019/06/wwdc_2_0.jpg",
              "https://applecoding.com/wp-content/uploads/2019/03/D3065977-B517-4B1F-913E-B6035E61A9D6-390x220.png",
              "https://applecoding.com/wp-content/uploads/2019/03/UI-Kit-apple-796x412-390x220.jpg",
              "https://applecoding.com/wp-content/uploads/2018/06/mapkitjs-portada-1024x576.jpg"]

class NetworkOperation: AsyncOperation {
    let url: URL
    var result: UIImage?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    override func main() {
        network { image in
            self.result = image
            self.state = .Finished
        }
    }
    
    func network(callback: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                if let error = error {
                    print("Error en la operación de red: \(error)")
                }
                self.state = .Finished
                return
            }
            if response.statusCode == 200 {
                if let image = UIImage(data: data) {
                    callback(image)
                } else {
                    print("No es una imagen")
                    self.state = .Finished
                }
            } else {
                print("Error \(response.statusCode)")
                self.state = .Finished
            }
        }.resume()
    }
}

class ImageTransform: Operation {
    var inputImage: UIImage?
    var outputImage: UIImage?
    
    override func main() {
        if let output = photoEffectMono(inputImage) {
            outputImage = output
            filteredImages.append(output)
        }
    }
    
    func photoEffectMono(_ input: UIImage?) -> UIImage? {
        let context = CIContext()
        let currentFilter = CIFilter.photoEffectMono()
        if let inputImg = input {
            currentFilter.inputImage = CIImage(image: inputImg)
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgimg)
                }
            }
        }
        return nil
    }
}

let queue = OperationQueue()
var filteredImages: [UIImage] = []

for image in images {
    if let url = URL(string: image) {
        let imageLoad = NetworkOperation(url: url)
        let filter = ImageTransform()
        // Creamos un puente que sirva de enlace entre las dos operaciones que nos interesan: bajar la imagen y aplicarle un filtro. Esto sería de forma externa
        let dataTransfer = BlockOperation {
            filter.inputImage = imageLoad.result // así inyectamos la dependencia
        }
        
        dataTransfer.addDependency(imageLoad) // esto es para que se espere a que se ejecute imageLoad para luego inyectar su resultado
        filter.addDependency(dataTransfer) // el filtro tiene que esperar a que termine lo anterior y se cargue la imagen
        //lo siguiente es añadir las operaciones a la cola en el orden que las queremos que se ejecuten
        queue.addOperations([imageLoad, dataTransfer, filter], waitUntilFinished: true)
    }
}

filteredImages.forEach {
    print($0)
    $0
}
