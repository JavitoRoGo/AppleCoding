//
//  Model.swift
//  TutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 3/12/21.
//

import Combine
import SwiftUI

// MARK: - Empleado
struct Empleado: Codable, Identifiable {
    let id: Int
    let firstName, lastName, email: String
    let gender: Gender
    let company: String
    let department: Department
    let jobtitle: String
    let longitude, latitude: Double
    let address, username: String
    let avatar: URL

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, gender, company, department, jobtitle, longitude, latitude, address, username, avatar
    }
}

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
    case agender = "Agender"
    case bigender = "Bigender"
    case female = "Female"
    case genderfluid = "Genderfluid"
    case genderqueer = "Genderqueer"
    case male = "Male"
    case nonBinary = "Non-binary"
    case polygender = "Polygender"
}


// MARK: - MVVM: Modelo-Vista-Vista-Modelo
// Es al revés de UIKit: aquí las vistas son structs y el modelo es una clase
// Tenemos que hacer que el modelo reaccione a los cambios y provoque que las vistas se actualicen. Eso se hace conformando la clase a ObservableObject, y la propiedad a Published
// Este property wraper emite una señal cada vez que la propiedad cambia, y permite que la interfaz se refresque

class EmpleadosModel: ObservableObject {
    @Published var empleados: [Empleado]
    
    init() {
        guard let url = Bundle.main.url(forResource: "EMPLEADOS", withExtension: "json") else {
            empleados = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            empleados = try JSONDecoder().decode([Empleado].self, from: data)
        } catch {
            print("Error en la carga: \(error)")
            empleados = []
        }
    }
    
}

// Esto es para descargar el avatar de cada empleado, que viene dado como un string con una web
class NetworkModel: ObservableObject {
    @Published var avatar = Image(systemName: "person.fill")
    
    var subscriber = Set<AnyCancellable>()
    func getImage(url: URL) {
        //la carga se hace con Combine, que es más difícil y largo de explicar. Usa además programación funcional de más alto nivel. Quedarse con el ejemplo y ya
        URLSession.shared //inicia sesión de red
            .dataTaskPublisher(for: url) //carga la url
            .map(\.data) //de la respuesta se queda solo con los datos
            .compactMap { UIImage(data: $0) } //pasa los datos al constructor y crear una UIImage
            .map { Image(uiImage: $0) } //pasa la imagen de UIKit a SwiftUI
            .replaceEmpty(with: Image(systemName: "person.fill")) //devuelve esta imagen si no ha encontrado la buscada
            .replaceError(with: Image(systemName: "person.fill")) //devuelve esta imagen en caso de error
            .assign(to: \.avatar, on: self) //asigna la imagen a la propiedad indicada
            .store(in: &subscriber) //se almacena en el suscriptor (cosas de combine)
    }
}
