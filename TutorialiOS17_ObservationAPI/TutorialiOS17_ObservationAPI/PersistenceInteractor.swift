//
//  PersistenceInteractor.swift
//  TutorialiOS17_ObservationAPI
//
//  Created by Javier Rodríguez Gómez on 20/9/23.
//

import Foundation

protocol PersistenceInteractor {
	var bundleURL: URL { get }
	var docURL: URL { get }
	
	func loadEmpleados() throws -> [Employee]
	func saveEmpleados(_ employees: [Employee]) throws
}

// A partir del protocolo anterior crearemos la persistencia de producción y de la preview: uno con EmployessData y otro con EmployeesDemo
// Pero las funciones de carga y guardado son exactamente iguales en los dos casos (y en cualquier otro struct que conforme a PersistenceInteractor)
// Por lo que, para no repetir el código de las funciones, usamos las propiedades de la orientación a protocolos: las extensiones de protocolos:
// se trata de dar un código "por defecto", a través de la extensión, a todos los que se conformen al protocolo

extension PersistenceInteractor {
	func loadEmpleados() throws -> [Employee] {
		var url = docURL
		if !FileManager.default.fileExists(atPath: url.path) {
			url = bundleURL
		}
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode([Employee].self, from: data)
	}
	
	func saveEmpleados(_ employees: [Employee]) throws {
		let data = try JSONEncoder().encode(employees)
		try data.write(to: docURL, options: .atomic)
	}
}

// struct de persistencia de datos para producción

struct Persistence: PersistenceInteractor {
	var bundleURL: URL {
		Bundle.main.url(forResource: "EmployeesData", withExtension: "json")!
	}
	
	var docURL: URL {
		// A partir de iOS15 esto sustituye la llamada a Filemanager
		URL.documentsDirectory.appending(path: "EmployeesData.json")
	}
}
