//
//  ContentView.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 18/6/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = EmpleadosVM()
    
    var body: some View {
        NavigationStack {
            List(vm.empleados) { empleado in
                NavigationLink(value: empleado) {
                    EmpleadoCell(empleado: empleado)
                }
            }
            .navigationDestination(for: Empleado.self) { empleado in
                EmpleadoDetail(empleado: empleado)
            }
            .alert("Error de empleados", isPresented: $vm.showAlert) {
                Button("OK") { }
            } message: {
                Text(vm.message)
            }
            .navigationTitle("Personas")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
