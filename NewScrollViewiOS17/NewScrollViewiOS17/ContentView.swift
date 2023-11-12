//
//  ContentView.swift
//  NewScrollViewiOS17
//
//  Created by Javier Rodríguez Gómez on 11/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		ScrollView(.horizontal) {
			LazyHStack {
				ForEach(1..<30) { num in
					RoundedRectangle(cornerRadius: 10)
						.fill(.orange)
						.frame(width: 150, height: 100)
					// la siguiente línea hace que se muestre solo un elemento porque está relacionado al contenedor y su eje horizontal
//						.containerRelativeFrame(.horizontal)
//						.containerRelativeFrame(.horizontal, count: 2, spacing: 10 )
						.overlay {
							Text(String(num))
								.font(.title)
								.foregroundStyle(.purple)
						}
					// efectos de transición
						.scrollTransition { content, phase in
							content
							// podemos jugar con la identidad, o elemento que se muestra al completo
								.scaleEffect(phase.isIdentity ? 1.0 : 0.8)
								.opacity(phase.isIdentity ? 1.0 : 0.5)
						}
				}
			}
			// mejor esto que un padding horizontal
			.safeAreaPadding(.horizontal)
			// para desplazarse con un comportamiento determinado
			.scrollTargetLayout()
		}
		// ocultar los indicadores de desplazamiento
		.scrollIndicators(.hidden)
		// para desplazarse con un comportamiento determinado
		.scrollTargetBehavior(.viewAligned)
		// ya no hace falta usar el ScrollViewReader para referencia el elemento, basta con asociarle un id a un elemento que lo identifique
//		.scrollPosition(id: $algo)
    }
}

#Preview {
    ContentView()
}
