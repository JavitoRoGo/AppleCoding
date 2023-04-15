//
//  Detalle.swift
//  TutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 3/12/21.
//

import SwiftUI

struct Detalle: View {
    let nombre: String
    
    var body: some View {
        Text(nombre).font(.largeTitle)
    }
}

struct Detalle_Previews: PreviewProvider {
    static var previews: some View {
        Detalle(nombre: "Prueba")
    }
}
