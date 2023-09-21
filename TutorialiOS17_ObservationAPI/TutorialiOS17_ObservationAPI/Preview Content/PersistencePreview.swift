//
//  PersistencePreview.swift
//  TutorialiOS17_ObservationAPI
//
//  Created by Javier Rodríguez Gómez on 20/9/23.
//

import Foundation

// struct de persistencia de datos para preview

struct PersistencePreview: PersistenceInteractor {
	var bundleURL: URL {
		Bundle.main.url(forResource: "EmployeesDemo", withExtension: "json")!
	}
	
	var docURL: URL {
		// A partir de iOS15 esto sustituye la llamada a Filemanager
		URL.documentsDirectory.appending(path: "EmployeesDemo.json")
	}
}

extension GestionViewModel {
	static let preview = GestionViewModel(employeesLogic: EmployeesLogic(persistence: PersistencePreview()))
	// esto es un ejemplo de inyección de dependencias
}

extension Employee {
	static let test = Employee(id: 1, firstName: "Javier", lastName: "Rodríguez", email: "tic@ticritus.com", gender: .male, department: .engineering, avatar: URL(string: "https://robohash.org/autemmodivelit.png?size=50x50&set=set1")!)
}
