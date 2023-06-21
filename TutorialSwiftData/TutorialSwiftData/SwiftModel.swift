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
    let id: UUID
    let name: String
    
    @Relationship(.cascade, inverse: \EmpleadoModel.department) var empleados: [EmpleadoModel]
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
// Si creamos una clase normal, con sus propiedades y su init y le añadimos @Model, ya se convierte de forma automática en una clase de CoreData y se van a guardar todas sus instancias
// Al ser un modelo, podemos usar atributos para las propiedades y hacer que sean únicos sus valores, o propagarlos a spotlight, cifrarlos, etc.

@Model
final class GenderModel {
    let id: UUID
    let name: String
    
    @Relationship(.cascade, inverse: \EmpleadoModel.gender) var empleados: [EmpleadoModel]
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

// los Model tienen que ser siempre final class, objetos por referencia, para que toda la app se actualice independientemente del lugar dónde actualicemos los datos

@Model
final class EmpleadoModel {
    @Attribute(.unique) let id: Int
    var username:String
    var firstName: String
    var lastName: String
    @Attribute(.encrypt) let email: String
    var address: String
    var avatar: URL
    var zipcode: String?
    // el género y el dpto lo añadimos a través de una relación, y es tan fácil como poner RelationShip
    // al incluirlo dentro de este modelo la relación es 1->n: 1 empleado tiene 1 género, pero 1 género tendrá varios empleados
    // las relaciones tienen que incluir, al menos, la regla de borrado:
        /*
         cascade: si borramos 1 género se borran todos los datos que tengan ese género
         deny: no permite borrar el género mientras exista 1 dato que tenga ese género
         noAction: borra el género pero no los datos
         nullify: si se borra un género, en los datos con ese género pasa a ser nil
         */
    @Relationship(.deny) var gender: GenderModel
    @Relationship(.deny) var department: DepartmentModel
    
    // con las relaciones no es necesario añadir un init, pero sí es muy recomendable para instanciarlos de forma más sencilla
    init(id: Int, username: String, firstName: String, lastName: String, email: String, address: String, avatar: URL, zipcode: String?, gender: GenderModel, department: DepartmentModel) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.address = address
        self.avatar = avatar
        self.zipcode = zipcode
        self.gender = gender
        self.department = department
    }
    
    // y hasta aquí ya estaría creado el modelo y las relaciones: NO es necesario crear la relación inversa de gender o department con EmpleadosModel
    // PERO, si creamos esa relación inversa, eso nos permite luego usarla para crear consultas, y saber los empleados que tienen un género o dpto concreto
    // esta relación inversa NO se incluye dentro del init
}
