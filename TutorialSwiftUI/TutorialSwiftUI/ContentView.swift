//
//  ContentView.swift
//  TutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 2/12/21.
//

import SwiftUI

struct ContentView: View {
    // un struct de tipo view crea pantallas en swiftUI; basta con crear uno y darle un nombre y tendremos otra vista o pantalla
    let nombres = ["Julio", "Antonio", "Paco", "José Miguel", "Paquito", "Dr.Evil"]
    
    var body: some View {
        // tipo opaco de retorno, este cuerpo es obligatorio ponerlo siempre y que sea de tipo some View
        // este body lo busca el sistema para pintar o mostrar lo que le pongamos dentro
        NavigationView {
            List {
                ForEach(nombres, id: \.self) { nombre in
                    NavigationLink(destination: Detalle(nombre: nombre)) {
                        Fila(nombre: nombre)
                    }
                }
            }
            .navigationTitle("Nombres")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    // esta es la preview, lo que queremos que muestre en el canvas
    static var previews: some View {
        Group {
            ContentView()
                
            ContentView()
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}


