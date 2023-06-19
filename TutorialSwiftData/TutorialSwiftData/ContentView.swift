//
//  ContentView.swift
//  TutorialSwiftData
//
//  Created by Javier Rodríguez Gómez on 19/6/23.
//

import SwiftUI

struct ContentView: View {
    // Ahora el modelo se carga con @State, ya no hay StateObject ni ObservedObject. Se usa en lo que sería la vista principal para usar la instancia completa de la clase en una sola vista
    // Si queremos pasar la instancia completa para trabajar en otras vistas se hace usando @Bindable
    @State var emp = EmpleadosVM()
    
    var body: some View {
        Text(emp.nombre)
    }
}

#Preview {
    ContentView()
}
// #Preview es una macro, y podemos ver el texto que implica expandiéndola con el botón derecho
// son bastantes complejas pero dan muchísimas utilidades
// son como un estado intermedio entre el código escrito y el código compilado o traducido
