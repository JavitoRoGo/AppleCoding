//
//  ContentView.swift
//  BatchImages
//
//  Created by Javier Rodríguez Gómez on 13/11/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var fotosVM = BatchImagesVM()
    // Columnas para el grid:
    let columns: [GridItem] = .init(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(fotosVM.fotos) { foto in
                    foto.image
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        //para que aparezcan las imágenes y llame a la red:
        .onAppear {
            fotosVM.getImages()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
