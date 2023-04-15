import CoreImage.CIFilterBuiltins
import UIKit

// En este último ejemplo vamos a hacer una única operación que ejecute múltiples acciones:
/*
    Recuperar 3 url en una
    Adaptar la operación de red para uso múltiple con varias dependencias
    Gestionar las dependencias
    Recuperar la imagen, y transformarla
 */
// La diferencia está en que la primera clase va a tener dependencias de sí misma para recuperar varias imágenes de la red

// Lo primero es el struct con los datos que queremos recuperar del json de artículos
struct Post: Identifiable, Codable {
    let id: Int
    let title: Rendered
    let content: Rendered
    let excerpt: Rendered
    
    struct Rendered: Codable {
        let rendered: String
    }
    
    struct Author: Codable {
        let href: URL
    }
    
    struct Links: Codable {
        let author: [Author]
    }
    let _links: Links
}

struct Author: Identifiable, Codable {
    let id: Int
    let name: String
    
    struct AvatarURL: Codable {
        let _24: URL
        let _48: URL
        let _96: URL
        
        enum CodingKeys: String, CodingKey {
            case _24 = "24"
            case _48 = "48"
            case _96 = "96"
        }
    }
    let avatar_urls: AvatarURL
}

class NetworkOperation: AsyncOperation {
    let url: URL
    var result: Data?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    override func main() {
        if let dependency = dependencies.first as? NetworkOperation,
           let data = dependency.result {
            let decoder = JSONDecoder()
            if let postJSON = try? decoder.decode([Post].self, from: data) {
                if let articulo = postJSON.first, let hrefAutor = articulo._links.author.first?.href {
                    network(url: hrefAutor) { data in
                        self.result = data
                        self.state = .Finished
                    }
                }
            } else if let authorJSON = try? decoder.decode(Author.self, from: data) {
                network(url: authorJSON.avatar_urls._96) { data in
                    self.result = data
                    self.state = .Finished
                }
            }
        } else {
            network(url: url) { data in
                self.result = data
                self.state = .Finished
            }
        }
    }
    
    func network(url: URL, callback: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                if let error = error {
                    print("Error en la operación de red: \(error)")
                }
                self.state = .Finished
                return
            }
            if response.statusCode == 200 {
                callback(data)
            } else {
                print("Error \(response.statusCode)")
                self.state = .Finished
            }
        }.resume()
    }
}

class ImageTransform: Operation {
    var outputImage: UIImage?
    
    override func main() {
        if let dependency = dependencies.first as? NetworkOperation, //gestiona la dependencia
           let data = dependency.result, //recupera los datos de la dependencia
           let inputImage = UIImage(data: data) { //transforma los datos en imagen
            outputImage = photoEffectMono(inputImage)
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

let urlPosts = URL(string: "https://applecoding.com/wp-json/wp/v2/posts")! //esto devuelve un json de la url
// la url es de una lista de artículos, y buscaremos el autor del primer artículo
// el autor está en otra url que devuelve otro json, y en ese json hay una url de imagen de avatar
// y ese avatar lo pasaremos por el filtro

let queue = OperationQueue() // cola de operaciones
// Primera operación de descarga del json de los posts
let postJSONOperation = NetworkOperation(url: urlPosts)

// Ahora hay que hacer que la dependencia del autor sea el resultado del post
let authorJSONOperation = NetworkOperation(url: urlPosts) //ponemos la misma url para inicializar pero no se va a usar como tal
authorJSONOperation.addDependency(postJSONOperation)

// Siguiente dependencia para obtener ahora el avatar
let avatarIMG = NetworkOperation(url: urlPosts)
avatarIMG.addDependency(authorJSONOperation)

// En este punto ya hemos recuperado el json de los posts, el json del autor del primer artículo, y el avatar del autor. Falta transformar la imagen
let filterAvatarImage = ImageTransform()
filterAvatarImage.addDependency(avatarIMG)

queue.addOperations([postJSONOperation, authorJSONOperation, avatarIMG, filterAvatarImage], waitUntilFinished: true)

filterAvatarImage.outputImage //muestra la imagen
