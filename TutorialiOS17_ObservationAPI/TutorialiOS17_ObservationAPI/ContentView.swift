//
//  ContentView.swift
//  TutorialiOS17_ObservationAPI
//
//  Created by Javier Rodríguez Gómez on 20/9/23.
//

import SwiftUI

struct ContentView: View {
	// Para recuperar el viewmodel de App se hace desde el entorno, indicando el protocolo que debe cumplir
	@Environment(GestionViewModel.self) var vm
	
    var body: some View {
		// Con la nueva API Apple se cargó todos los bindings, por lo que tenemos que declararlo explícitamente si lo queremos
		// Y sí, se hace en este punto dentro del body, par poder acceder al Bool de vm
		@Bindable var empBinding = vm.employeesLogic
		
		NavigationStack {
			List(vm.employeesLogic.employees) { employee in
				NavigationLink(value: employee) {
					EmployeeCell(employee: employee)
				}
			}
			.navigationTitle("Employees")
			.navigationDestination(for: Employee.self) { employee in
				DetailEmployee(employee: employee)
			}
		}
		// ahora la alerta debe ir aquí para que funcione
		.alert("Application error.",
			   isPresented: $empBinding.showAlert) {
		} message: {
			Text(vm.employeesLogic.message)
		}
    }
}

#Preview {
	ContentView()
		.environment(GestionViewModel.preview)
}
