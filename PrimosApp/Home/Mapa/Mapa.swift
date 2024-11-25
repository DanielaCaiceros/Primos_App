//
//  Mapa.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI

struct Mapa: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var isShowingPopover: Bool = false
    @State private var selectedZona: Zona? = nil
    @StateObject private var actividadesModelo = ActividadesModelo()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Image("PB_mapa")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .scaleEffect(min(max(scale, 1.0), 3.0))
                        .offset(x: offset.width, y: offset.height)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScaleValue * value
                                }
                                .onEnded { _ in
                                    lastScaleValue = scale
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                    
                    if !actividadesModelo.zonas.isEmpty {
                        ForEach(actividadesModelo.zonas) { zona in
                            Button(action: {
                                selectedZona = zona
                                isShowingPopover = true
                                Task {
                                    await actividadesModelo.getActividadesPorZona(zonaId: zona.id)
                                }
                            }) {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 100, height: 100)
                            }
                            .position(x: CGFloat(zonaPosition(zona: zona).x) * scale + offset.width + geometry.size.width / 2,
                                      y: CGFloat(zonaPosition(zona: zona).y) * scale + offset.height + geometry.size.height / 2)
                        }
                    }
                }
                .popover(isPresented: $isShowingPopover) {
                    if let zona = selectedZona {
                        ActividadesView(actividadesModelo: actividadesModelo, zona: zona)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Mapa Planta Alta", displayMode: .inline)
            .onAppear {
                Task {
                    await actividadesModelo.getZonas() // Cargar zonas desde Firebase
                }
            }
        }
    }
    
    private func zonaPosition(zona: Zona) -> (x: Int, y: Int) {
        switch zona.nombre {
        case "Soy":
            return (x: 125, y: 100)
        case "Pequeños":
            return (x: 175, y: -200)
        case "Expreso":
            return (x: -100, y:-200)
        case "Comprendo":
            return (x: -175, y: 50)
        default:
            return (x: 0, y: 0) // Coordenadas por defecto si no coincide con ninguna zona
        }
    }
}


/*struct Mapa1_Previews: PreviewProvider {
    static var previews: some View {
        Mapa()
            .environmentObject(MockActividadesModelo())
    }
}

// Modelo de actividades falso para la vista previa
class MockActividadesModelo: ActividadesModelo {
    override init() {
        super.init()
        // Mock de zonas para la vista previa
        self.zonas = [
            Zona(id: "1", nombre: "Exposiciones temporales", color: "#FF5733", foto: "example_photo"),
            Zona(id: "2", nombre: "Pertenezco", color: "#33FF57", foto: "example_photo"),
            Zona(id: "3", nombre: "Pequeños", color: "#3357FF", foto: "example_photo"),
            Zona(id: "4", nombre: "Comunico", color: "#57FF33", foto: "example_photo"),
        ]
    }
}*/
