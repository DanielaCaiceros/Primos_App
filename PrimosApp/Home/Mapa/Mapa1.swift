//
//  Mapa1.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 28/10/24.
//
import SwiftUI

struct Mapa1: View {
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
                    Image("PA_mapa")
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
                                    .fill(Color.black)
                                    .frame(width: 100, height: 100) // Ajustar dimensiones según la zona
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
                    await actividadesModelo.getZonas()
                }
            }
        }
    }
    
    private func zonaPosition(zona: Zona) -> (x: Int, y: Int) {
        switch zona.nombre {
        case "Pertenezco":
            return (x: -90, y: -150)
        case "Pequeños":
            return (x: 225, y: -185)
        case "Comunico":
            return (x: 150, y: 15)
        default:
            return (x: 0, y: 0)
        }
    }
}


