import CoreImage.CIFilterBuiltins
import UIKit

// Crearemos una clase propia de Operation para transforma una imagen con un filtro de CoreImage

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

// Probar el funcionamiento
if let image = UIImage(named: "imagen_de_muestra.jpg") {
    image
    let imageTransform = ImageTransform(image: image)
    imageTransform.start()
    imageTransform.outputImage
}
