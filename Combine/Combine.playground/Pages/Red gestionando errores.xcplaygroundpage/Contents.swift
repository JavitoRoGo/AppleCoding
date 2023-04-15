//: [Previous](@previous)

import Combine
import SwiftUI

// RED GESTIONANDO ERRORES

// Hemos visto como descargar algo de la red, y ahora veremos cómo gestionar los posibles errores pero de manera mejor y más detallada que en los ejemplos anteriores

enum Department: String, Codable {
    case accounting = "Accounting"
    case businessDevelopment = "Business Development"
    case engineering = "Engineering"
    case humanResources = "Human Resources"
    case legal = "Legal"
    case marketing = "Marketing"
    case productManagement = "Product Management"
    case researchAndDevelopment = "Research and Development"
    case sales = "Sales"
    case services = "Services"
    case support = "Support"
    case training = "Training"
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}

struct EmpleadosModel:Codable, Identifiable {
    let id:Int
    let username:String
    let first_name:String
    let last_name:String
    let gender:Gender
    let email:String
    let department:Department
    let address:String
    let avatar:URL
}

let urlEmpleados = URL(string: "https://acoding.academy/testData/EmpleadosData.json")! //para descargar los datos
let urlTest200_5 = URL(string: "https://httpstat.us/200?sleep=5000")! // para provocar el ok pero tras 5 segundos
let urlTest404 = URL(string: "https://httpstat.us/404")! //para provocar error 404 not found
// las dos líneas anteriores refieren a una web que simula distintos status code para pruebas

enum NetworkErrors:Error {
    case general(String)
    case timeout(String)
    case notFound(String)
    case badConnection(String)
}

var subscribers = Set<AnyCancellable>()

//let configuration = URLSessionConfiguration.ephemeral
//configuration.timeoutIntervalForRequest = 3
//let session = URLSession(configuration: configuration)

// Otra forma de hacerlo es no usar las 3 líneas anteriores (comentadas) y añadir un parámetro .timeout para controlar ese timeout después de la línea del retry

URLSession.shared.dataTaskPublisher(for: urlEmpleados)
    .mapError { error -> NetworkErrors in // para cambiar el error que devuelve por nuestros errores
        if error.errorCode == -1001 { //este es el código de error de timeout
            return .timeout(error.localizedDescription)
        } else {
            return .general(error.localizedDescription)
        }
    }
    .retry(3) //para hacer 3 intentos de conexión antes de lanzar algún error de tipo fallo en la conexión
    .timeout(.seconds(3), scheduler: RunLoop.current, options: nil) {
        .timeout("Ha tardado más de 3 segundos")
    }
    .tryMap { (data, response) -> Data in
        guard let response = response as? HTTPURLResponse else {
            throw NetworkErrors.badConnection("Conexión errónea")
        }
        if response.statusCode == 200 {
            return data
        } else {
            throw NetworkErrors.notFound("Status code \(response.statusCode)")
        }
    } // en este punto lanzamos error de mala conexión si no hay respuesta, error con su código de no encontrado, o los datos si todo ha ido bien
    .decode(type: [EmpleadosModel].self, decoder: JSONDecoder()) //datos pasados a nuestro struct
    .sink { completion in
        if case .failure(let error) = completion,
           let networkError = error as? NetworkErrors {
            switch networkError {
            case .general(let mensaje):
                print("Error general: \(mensaje)")
            case .timeout(let mensaje):
                print("Tiemout: \(mensaje)")
            case .notFound(let mensaje):
                print("Not Found: \(mensaje)")
            case .badConnection(let mensaje):
                print("Bad Connection: \(mensaje)")
            }
        }
    } receiveValue: { empleados in
        print(empleados.first!)
    }
    .store(in: &subscribers)



//: [Next](@next)
