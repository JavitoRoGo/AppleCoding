//
//  Persistence.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 18/6/23.
//

import Foundation

final class Persistence {
    // ejemplo de patrón singleton, que es con una propiedad estática
    // la propiedad estática pertenece a la propia clase y no a la instancia
    static let shared = Persistence()
    
    // es buena práctica hacer un init vacío para que luego no nos permita inicializar sino a través del singleton
    private init() { }
    
    let url = URL(string: "https://acoding.academy/testData/EmpleadosData.json")!
    
    // carga de datos con async-await y throws, con solo 3 líneas
    func loadEmpleados() async throws -> [Empleado] {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badURL) }
        return try JSONDecoder().decode([Empleado].self, from: data)
    }
    
    // aquí iría la parte de guardado de los datos que añadamos o modifiquemos
    
    // ejemplo de autorización con basicAuth
    func authBasic(username: String, password: String) async throws {
        var request = URLRequest(url: url)
        guard let auth = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else { return }
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badURL) }
        try JSONDecoder().decode([Empleado].self, from: data)
    }
}
