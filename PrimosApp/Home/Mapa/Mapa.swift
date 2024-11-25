//
//  Mapa.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

/*import SwiftUI

struct Mapa: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var isShowingPopover: Bool = false
    @State private var selectedArea: String = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Imagen del mapa con zoom y desplazamiento
                Image("PB_mapa")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(min(max(scale, 0.5), 3.0)) // Permite zoom out hasta 0.5x y zoom in hasta 3.0x
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
                
                //SOY
                Button(action: {
                    selectedArea = "Soy"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 200, height: 200)
                }
                .position(x: 50 * scale + offset.width + geometry.size.width / 2,
                          y: 125 * scale + offset.height + geometry.size.height / 2)
                Button(action: {
                    selectedArea = "Soy"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 300, height: 200)
                }
                .position(x: 225 * scale + offset.width + geometry.size.width / 2,
                          y: -15 * scale + offset.height + geometry.size.height / 2)
                Button(action: {
                    selectedArea = "Soy"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 125, height: 125)
                }
                .position(x: 210 * scale + offset.width + geometry.size.width / 2,
                          y: 145 * scale + offset.height + geometry.size.height / 2)
                
                //PEQUEÑOS
                Button(action: {
                    selectedArea = "Pequeños"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 300, height: 100)
                }
                .position(x: 200 * scale + offset.width + geometry.size.width / 2,
                          y: -200 * scale + offset.height + geometry.size.height / 2)
                
                //EXPRESSO
                Button(action: {
                    selectedArea = "Expresso"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 300, height: 100)
                }
                .position(x: -20 * scale + offset.width + geometry.size.width / 2,
                          y: -350 * scale + offset.height + geometry.size.height / 2)
                Button(action: {
                    selectedArea = "Expresso"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)
                }
                .position(x: -90 * scale + offset.width + geometry.size.width / 2,
                          y: -175 * scale + offset.height + geometry.size.height / 2)
                
                //COMPRENDO
                Button(action: {
                    selectedArea = "Expresso"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 350, height: 200)                }
                .position(x: -225 * scale + offset.width + geometry.size.width / 2,
                          y: 50 * scale + offset.height + geometry.size.height / 2)
            }
            .popover(isPresented: $isShowingPopover) {
                VStack {
                    Text("Información sobre \(selectedArea)")
                        .font(.headline)
                    Text("Descripción detallada del área seleccionada.")
                        .font(.subheadline)
                    Button("Cerrar") {
                        isShowingPopover = false
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Mapa Planta Baja", displayMode: .inline)
    }
}

#Preview {
    Mapa()
}
*/
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
                    // Imagen del mapa con gestos de zoom y desplazamiento
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
                    
                    // Botones interactivos para diferentes zonas del mapa
                    if !actividadesModelo.zonas.isEmpty {
                        ForEach(actividadesModelo.zonas) { zona in
                            Button(action: {
                                selectedZona = zona
                                isShowingPopover = true
                                Task {
                                    // Cargar las actividades de la zona seleccionada
                                    await actividadesModelo.getActividadesPorZona(zonaId: zona.id)
                                }
                            }) {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 200, height: 200) // Ajustar dimensiones según la zona
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
    
    // Función para obtener la posición de una zona en el mapa
    private func zonaPosition(zona: Zona) -> (x: Int, y: Int) {
        // Ajustar las posiciones según la zona
        switch zona.nombre {
        case "Soy":
            return (x: 50, y: 125)
        case "Pequeñps":
            return (x: 200, y: -200)
        case "Expresso":
            return (x: -20, y: -350)
        case "Comprendo":
            return (x: -225, y: 50)
        default:
            return (x: 0, y: 0) // Coordenadas por defecto si no coincide con ninguna zona
        }
    }
}
