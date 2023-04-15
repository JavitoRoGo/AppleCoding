import Foundation

// RESULTADOS OPCIONALES CON TRY? Y TRY!

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
let producto1: [String:Any] = ["product": "Star Wars Rogue One Bluray", "units": 100, "price": 16]
let producto2: [String:Any] = ["product": "Apple iPhone 7 Plus", "units": 50]


let blurays = try? Producto(JSON: producto2) //falta el precio por lo que devuelve nil, o un opcional si estuviera bien
//con try? los throw de los errores es como si devolviera nil y no los errores que le indicamos
//con try! nos devuelve el dato ya desempaquetado, pero da un error fatal si no se puede
