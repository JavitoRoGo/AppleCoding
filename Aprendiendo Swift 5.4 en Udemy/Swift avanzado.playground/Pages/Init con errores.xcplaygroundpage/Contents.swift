import Foundation

// INICIALIZADORES QUE LANZAN ERRORES

/* Ejemplo: tenemos un protocolo que simula abrir un proceso para leer un json y luego lo cierra
 Y creamos un producto del struct que lo lee del json que le pasamos ya como dicctionario
 Pero tendremos que crear y manejar los errores si el producto no está en el json o está mal escrito*/

protocol ProductoDelegate {
    func abrimosProceso()
    func cerramosProceso()
}
enum errorProducto: Error {
    case noProducto, noInventario, noPrecio
}
struct Producto {
    var delegate: ProductoDelegate?
    var nombre: String
    var precio: Int
    var unidades: Int
    
    init(JSON: [String:Any]) throws {
        delegate?.abrimosProceso()
        guard let productoJSON = JSON["product"] as? String else {
            throw errorProducto.noProducto
        }
        guard let inventarioJSON = JSON["units"] as? Int else {
            throw errorProducto.noInventario
        }
        guard let precioJSON = JSON["price"] as? Int else {
            throw errorProducto.noPrecio
        }
        self.nombre = productoJSON
        self.unidades = inventarioJSON
        self.precio = precioJSON
        defer {
            delegate?.cerramosProceso()
        }
    }
}

