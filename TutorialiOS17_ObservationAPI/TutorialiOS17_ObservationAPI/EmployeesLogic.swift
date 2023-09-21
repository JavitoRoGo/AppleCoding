//
//  EmployeesLogic.swift
//  TutorialiOS17_ObservationAPI
//
//  Created by Javier Rodríguez Gómez on 20/9/23.
//

import SwiftUI


// Desaparece el uso de ObservableObject, Published, StateObject, EnvironmentObject...
// Todo eso se sustituye por Observable; y todo lo que vaya dentro de la clase, pasa a ser automáticamente como Published

@Observable
final class EmployeesLogic {
	// Patrón singleton para hacer que todas las instancias del viewmodel tiren de los mismos datos: cada vez que esta clase sea llamada por GestioViewModel llamará a la instancia shared. También sirve para hacer más fácil la inyección de dependencias
	static let shared = EmployeesLogic()
	
	// Para los datos usamos la persistencia del interactor, con una propiedad de tipo del protocolo, para poder enviarle tanto el struct de producción como el de preview
	let persistence: PersistenceInteractor
	var employees: [Employee]
	
	var showAlert = false
	var message = ""
	
	init(persistence: PersistenceInteractor = Persistence()) { // ponemos el valor por defecto del struct de producción para que lo coja por defecto
		self.persistence = persistence
		do {
			self.employees = try persistence.loadEmpleados()
		} catch {
			self.employees = []
			message = error.localizedDescription
			showAlert.toggle()
		}
	}
}


// Esta lógica es como si fuera el ViewModel usado hasta ahora, y habría una lógica por cada modelo de datos
