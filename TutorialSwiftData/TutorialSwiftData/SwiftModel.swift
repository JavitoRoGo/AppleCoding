//
//  SwiftModel.swift
//  TutorialSwiftData
//
//  Created by Javier Rodríguez Gómez on 19/6/23.
//

import SwiftData
import SwiftUI

// El modelo ya no se conforma con ObservableObject, sino con @Observable; y, automáticamente, todas las propiedades que pongamos dentro pasan a ser visibles y actualizan la interfaz como si fuera el "antiguo" Published. Lo único es que estas propiedades tienen que tener un valor de inicialización de forma obligatoria (o ser opcionales)

// El modelo Empleado es el que se usa para cargar los datos desde la fuente externa, pero sus propiedades son let y no podremos cambiarlas
// Por eso se crea el modelo EmpleadosVM de tipo Observable, que sí permite actualizar los datos
// Y hacen falta los dos porque un struct no puede ser Codable y Observable a la misma vez porque no funciona bien

@Observable
final class EmpleadosVM {
    var nombre: String = ""
    var apellidos: String = ""
}

@Model
final class DepartmentModel {
    @Attribute(.unique) let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
// Si creamos una clase normal, con sus propiedades y su init y le añadimos @Model, ya se convierte de forma automática en una clase de CoreData y se van a guardar todas sus instancias
// Al ser un modelo, podemos usar atributos para las propiedades y hacer que sean únicos sus valores, o propagarlos a spotlight, cifrarlos, etc.
