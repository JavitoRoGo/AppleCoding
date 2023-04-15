import UIKit

// Las operaciones son síncronas porque gestionan sus propios estados, pero veremos cómo hacer operaciones asíncronas, por ejemplo, para llamadas de red
// Para ello creamos nuestra subclase asíncrona en un fichero aparte dentro de Sources. Este fichero nos valdría para llevarlo a cualquier otro proyecto
// El primer ejemplo es recuperar varias imágenes de la red de forma asíncrona

let images = ["https://applecoding.com/wp-content/uploads/2019/06/combine-operators-1024x573-1024x576.jpg",
              "https://applecoding.com/wp-content/uploads/2019/06/wwdc_2_0.jpg",
              "https://applecoding.com/wp-content/uploads/2019/03/D3065977-B517-4B1F-913E-B6035E61A9D6-390x220.png",
              "https://applecoding.com/wp-content/uploads/2019/03/UI-Kit-apple-796x412-390x220.jpg",
              "https://applecoding.com/wp-content/uploads/2018/06/mapkitjs-portada-1024x576.jpg"]
var loadImages: [UIImage] = []

class NetworkOperation: AsyncOperation {
    let url: URL
    var result: UIImage?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    override func main() {
        network { image in
            loadImages.append(image)
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

// Vamos a probar si funciona
let queue = OperationQueue()

for image in images {
    if let url = URL(string: image) {
        let imageOperation = NetworkOperation(url: url)
        queue.addOperation(imageOperation)
    }
}

queue.waitUntilAllOperationsAreFinished()
loadImages.forEach {
    print($0)
    $0
}
