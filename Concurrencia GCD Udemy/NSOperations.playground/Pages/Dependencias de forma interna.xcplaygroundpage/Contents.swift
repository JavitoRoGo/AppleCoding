import CoreImage.CIFilterBuiltins
import UIKit

// En este caso vamos a hacer lo mismo que la página anterior, pero de otra forma un poco mejor, de forma interna

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
        // aquí también cambia con el ejemplo anterior, porque la entrada de esta clase tiene que ser la salida de la otra
        if let dependency = dependencies.first as? NetworkOperation,
           let image = dependency.result {
            outputImage = photoEffectMono(image)
            if let output = outputImage {
                filteredImages.append(output)
            }
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
        // El cambio con respecto al ejemplo anterior empieza aquí: lo haremos de forma interna, sin otra operación que haga de puente, sino que inyectamos de forma directa
        filter.addDependency(imageLoad)
        queue.addOperations([imageLoad, filter], waitUntilFinished: true)
    }
}

filteredImages.forEach {
    print($0)
    $0
}

