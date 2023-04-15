//
//  TutorialSwiftUIApp.swift
//  TutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 2/12/21.
//

import SwiftUI

@main // indica al sistema el punto de inicio del programa
struct TutorialSwiftUIApp: App { // struct de tipo App
    @StateObject var empleados = EmpleadosModel()
    //con esta línea aquí tenemos el modelo accesible a toda la app en todas sus vistas y pestañas, y al ser un objeto de estado, si cambia un dato en cualquier vista se actualiza automáticamente en todas
    
    var body: some Scene { // crea una escena
        WindowGroup { // grupo de ventanas
            EmpleadosView() // muestra nuestra vista principal
                .environmentObject(empleados) //inyectamos un objeto de entorno con la instancia del modelo
        }
    }
}
