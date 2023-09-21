//
//  GestionViewModel.swift
//  TutorialiOS17_ObservationAPI
//
//  Created by Javier Rodríguez Gómez on 20/9/23.
//

import SwiftUI

@Observable
final class GestionViewModel {
	// Aquí tendríamos una instancia por cada Logic o lógica de datos que tuviéramos
	var employeesLogic: EmployeesLogic
	
	init(employeesLogic: EmployeesLogic = .shared) {
		self.employeesLogic = employeesLogic
	}
}


// Este viewmodel es como una especie de aglutinador de todas las lógicas que pueda haber en la app
// Como este ejemplo es sencillo con una sola lógica, se puede omitir este paso
