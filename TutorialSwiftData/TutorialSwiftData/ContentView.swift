//
//  ContentView.swift
//  TutorialSwiftData
//
//  Created by Javier Rodríguez Gómez on 19/6/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    // Antes de mostrar los datos hay que hacer una consulta
    @Query(sort: \.lastName) private var empleados: [EmpleadoModel]
    // Para guardar el elemento creado hay que recuperar el contexto del entorno
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List(empleados) { empleado in
                NavigationLink(value: empleado) {
                    EmpleadoCell(empleado: empleado)
                }
            }
            .navigationDestination(for: EmpleadoModel.self) { empleado in
                    EmpleadoDetail(empleado: empleado)
            }
            .navigationTitle("Empleados")
        }
    }
}

#Preview {
    // en la preview hay que pasar los modelos y el contexto
    ContentView()
        .modelContainer(for: [
            GenderModel.self,
            DepartmentModel.self,
            EmpleadoModel.self
        ], inMemory: true) // inMemory es para que lo haga en memoria, que no grabe para que no afecte a los datos reales
}
// #Preview es una macro, y podemos ver el texto que implica expandiéndola con el botón derecho
// son bastantes complejas pero dan muchísimas utilidades
// son como un estado intermedio entre el código escrito y el código compilado o traducido


/*
 
 Ejemplo de uso de un modelo con el nuevo patrón @Observable
 struct ContentView: View {
 // Ahora el modelo se carga con @State, ya no hay StateObject ni ObservedObject. Se usa en lo que sería la vista principal para usar la instancia completa de la clase en una sola vista
 // Si queremos pasar la instancia completa para trabajar en otras vistas se hace usando @Bindable
 @State var emp = EmpleadosVM()
 
 var body: some View {
 Text(emp.nombre)
 }
 }
 
 */
