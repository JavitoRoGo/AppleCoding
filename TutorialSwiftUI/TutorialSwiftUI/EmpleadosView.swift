//
//  Empleados.swift
//  TutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 3/12/21.
//

import SwiftUI

struct EmpleadosView: View {
    //@State var texto: String = ""
    //este property wraper permite cambiar la propiedad in situ. Es un clase que en este caso apunta a la propiedad texto y que es mutable
    //al usar esta propiedad mutable hay que hacerlo en su estado Binding, que es con $
    
    //con la siguiente línea introducimos el modelo en nuestra app
    //@ObservedObject var empleados = EmpleadosModel()
    //el problema del estado anterior es que es válido para un solo nivel o vista, y puede dar problema si vamos y venimos de vista o si cambia en otra vista (creo que es así). Así que mejor ponerlo de la siguiente manera
    //@StateObject var empleados = EmpleadosModel()
    //además, para poder usar el modelo en toda la app nos llevamos la vista anterior al primer archivo que contiene el arranque de la app, creando también un objeto de entorno
    @EnvironmentObject var empleados: EmpleadosModel
    //al llevarnos el objeto de estado al inicializador de la app, lo correcto es que nuestra var sea un objeto de entorno. No tenemos que inicializar el parámetro, pero sí la preview
    
    var body: some View {
        //TextField("Introduzca un texto", text: $texto).padding()
        NavigationView {
            List {
                ForEach(empleados.empleados) { empleado in
                    EmpleadoRow(empleado: empleado)
                }
            }
            .listStyle(.automatic)
            .navigationTitle("Empleados")
            .navigationBarItems(trailing:
                //con HStack aquí podemos poner varios botones, cada uno con su código claro
                Button(action: {
                    //código de acción del botón
                }, label: {
                Image(systemName: "plus")}
                )
            )
        }
    }
}

struct Empleados_Previews: PreviewProvider {
    static var previews: some View {
        EmpleadosView()
            .environmentObject(EmpleadosModel())
    }
}

struct EmpleadoRow: View {
    let empleado: Empleado
    @ObservedObject var imagenEmpleado = NetworkModel()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(empleado.lastName), \(empleado.firstName)")
                Text(empleado.email)
                    .font(.footnote)
            }
            Spacer()
            imagenEmpleado.avatar
                .resizable()
                .frame(width: 50, height: 50)
                .background(Color.gray)
                .cornerRadius(15)
        }
        .onAppear {
            imagenEmpleado.getImage(url: empleado.avatar)
        }
    }
}
