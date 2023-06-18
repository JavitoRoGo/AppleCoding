//
//  ContentView.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 18/6/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = EmpleadosVM()
    
    var body: some View {
        NavigationStack {
            List(vm.empleados) { empleado in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(empleado.lastName), \(empleado.firstName)")
                            .font(.headline)
                        Text(empleado.email)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text(empleado.department.rawValue)
                            .padding(.top)
                    }
                    Spacer()
                    AsyncImage(url: empleado.avatar) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .background(Color(white: 0.9))
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                    }
                }
            }
            .alert("Error de empleados", isPresented: $vm.showAlert) {
                Button("OK") { }
            } message: {
                Text(vm.message)
            }
            .navigationTitle("Personas")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
