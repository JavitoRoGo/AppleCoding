//
//  TutorialSwiftDataApp.swift
//  TutorialSwiftData
//
//  Created by Javier Rodríguez Gómez on 19/6/23.
//

// Para usar SwiftData tenemos que propagar desde aquí el contenedor de los modelos, que es un array con todos los @Model creados. Pero como están todos relacionados puede pasarse uno solo
// Se hace desde el inicio de la app y desde el WindowGroup para que esté disponible para todas las ventanas

// El closure tras modelContainer es para cargar los datos desde la url

import SwiftUI
import SwiftData

@main
struct TutorialSwiftDataApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:  [EmpleadoModel.self]) { resutl in
            if case .success(let container) = resutl {
                Task {
                    do {
                        try await loadData(container: container)
                    } catch {
                        print("Ha petado: \(error)")
                    }
                }
            }
        }
    }
    
    // hay que poner MainActor porque el acceso al contexto es asíncrono, el mainContext del container
    @MainActor func loadData(container: ModelContainer) async throws {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badURL) }
        let empleados = try JSONDecoder().decode([Empleado].self, from: data)
        
        // como tenemos el container ya podemos cargar los datos
        let context = container.mainContext
        try empleados.forEach { empleado in
            // si ya existe un registro con ese id lo descartamos, y si no lo creamos
            // fetch es la consulta a la base de datos
            let id = empleado.id
            let empFetch = FetchDescriptor<EmpleadoModel>(
                predicate: #Predicate { $0.id == id }
            )
            if try context.fetch(empFetch).count == 0 {
                let gender = try getGender(context: context, gender: empleado.gender)
                let dpto = try getDepartment(context: context, dpto: empleado.department)
                let newEmp = EmpleadoModel(id: empleado.id, username: empleado.username, firstName: empleado.firstName, lastName: empleado.lastName, email: empleado.email, address: empleado.address, avatar: empleado.avatar, zipcode: empleado.zipcode, gender: gender, department: dpto)
                context.insert(object: newEmp)
            }
        }
    }
    
    // funciones para recuperar el departamento y género
    @MainActor func getDepartment(context: ModelContext, dpto: Department) throws -> DepartmentModel {
        let descDpto = dpto.rawValue
        let dptoFetch = FetchDescriptor<DepartmentModel>(
            predicate: #Predicate { $0.name == descDpto }
        )
        let fetch = try context.fetch(dptoFetch)
        if let department = fetch.first {
            return department
        } else {
            let new = DepartmentModel(id: UUID(), name: dpto.rawValue)
            return new
        }
    }
    @MainActor func getGender(context: ModelContext, gender: Gender) throws -> GenderModel {
        let descGender = gender.rawValue
        let genderFetch = FetchDescriptor<GenderModel>(
            predicate: #Predicate { $0.name == descGender }
        )
        let fetch = try context.fetch(genderFetch)
        if let gender = fetch.first {
            return gender
        } else {
            let new = GenderModel(id: UUID(), name: gender.rawValue)
            return new
        }
    }
}
