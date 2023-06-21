//
//  EmpleadoCell.swift
//  TutorialSwiftData
//
//  Created by Javier Rodríguez Gómez on 21/6/23.
//

import SwiftUI

struct EmpleadoCell: View {
    let empleado: EmpleadoModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(empleado.lastName), \(empleado.firstName)")
                    .font(.headline)
                Text(empleado.email)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            AsyncImage(url: empleado.avatar) { image in
                image
                    .resizable()
                    .symbolVariant(.circle)
                    .scaledToFit()
                    .frame(width: 60)
                    .background(Color(white: 0.9))
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person")
                    .resizable()
                    .symbolVariant(.circle)
                    .scaledToFit()
                    .frame(width: 60)
                    .background(Color(white: 0.9))
                    .clipShape(Circle())
            }
        }
    }
}
