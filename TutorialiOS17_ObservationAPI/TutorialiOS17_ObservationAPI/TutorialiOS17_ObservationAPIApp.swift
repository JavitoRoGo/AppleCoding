//
//  TutorialiOS17_ObservationAPIApp.swift
//  TutorialiOS17_ObservationAPI
//
//  Created by Javier Rodríguez Gómez on 20/9/23.
//

import SwiftUI

@main
struct TutorialiOS17_ObservationAPIApp: App {
	// Aquí se inyecta el viewmodel en toda la app como State, ya no hay StateObject
	// y se pasa a través de environment y NO de environmentObject
	@State var vm = GestionViewModel()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(vm)
        }
    }
}
