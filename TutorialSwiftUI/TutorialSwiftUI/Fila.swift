//
//  Fila.swift
//  TutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 3/12/21.
//

import SwiftUI

struct Fila: View {
    let nombre: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(nombre)
                    .font(.headline)
                Text("Hola")
                    .font(.footnote)
            }
            Spacer()
            Image(systemName: "pencil")
                .font(.title)
        }
    }
}

struct Fila_Previews: PreviewProvider {
    static var previews: some View {
        Fila(nombre: "Test")
    }
}
