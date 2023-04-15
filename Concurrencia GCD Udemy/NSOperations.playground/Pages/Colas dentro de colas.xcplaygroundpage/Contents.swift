import CoreImage.CIFilterBuiltins
import UIKit

// Retomamos este ejemplo pero para transformar varias imágenes: que las tranforme una a una pero que espere a que estén todas y obtenga un único resultado final

class ImageTransform: Operation {
    var inputImage: UIImage
    var outputImage: UIImage?
    
    init(image: UIImage) {
        self.inputImage = image
    }
    
    override func main() {
        // Este método se va a ejecutar al poner la clase en una cola o al llamar a start
        gaussianBlur(radius: 10)
    }
    
    func gaussianBlur(radius: Float) {
        let context = CIContext()
        let filter = CIFilter.gaussianBlur()
        filter.radius = radius
        filter.inputImage = CIImage(image: inputImage)
        if let output = filter.outputImage,
           let cgImg = context.createCGImage(output, from: output.extent) {
            outputImage = UIImage(cgImage: cgImg)
        }
    }
}

let images = ["imagen_de_muestra", "imagen_de_muestra_2", "imagen_de_muestra_3", "imagen_de_muestra_4", "imagen_de_muestra_5"].compactMap { //hacemos esto para ya cargar las imágenes y de paso eliminar los opcionales
    UIImage(named: "\($0).jpg")
}

var filteredImages: [UIImage] = []

let filterQueue = OperationQueue()
let appendQueue = OperationQueue()

for image in images {
    let filterOperation = ImageTransform(image: image)
    filterOperation.completionBlock = {
        guard let output = filterOperation.outputImage else { return }
        appendQueue.addOperation {
            filteredImages.append(output)
        }
    }
    filterQueue.addOperation(filterOperation)
}

filterQueue.waitUntilAllOperationsAreFinished()

filteredImages.forEach {
    print($0)
    $0
}
