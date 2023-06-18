//
//  EmpleadosVM.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 18/6/23.
//

import SwiftUI

final class EmpleadosVM: ObservableObject {
    let persistence = Persistence.shared
    
    @Published var empleados: [Empleado] = []
    @Published var showAlert = false
    @Published var message = ""
    
    init() {
        Task { await getEmpleados() }
    }
    
    // se usa el modificador MainActor porque la función modifica a empleados, que está dentro de un Published y que va a modificar la interfaz; para decirle que lo haga en el hilo principal
    @MainActor func getEmpleados() async {
        // esta función llama a la persistencia, que es async throws, pero es solo async para controlar los errores aquí
        do {
            empleados = try await persistence.loadEmpleados()
        } catch {
            message = error.localizedDescription
            showAlert.toggle()
        }
    }
}
