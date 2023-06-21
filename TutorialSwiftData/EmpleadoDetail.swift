//
//  EmpleadoDetail.swift
//  TutorialSwiftData
//
//  Created by Javier Rodríguez Gómez on 21/6/23.
//

import SwiftUI

struct EmpleadoDetail: View {
    @Bindable var empleado: EmpleadoModel
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("First name")
                    .font(.headline)
                TextField("Enter the first name", text: $empleado.firstName)
            }
        }
    }
}
