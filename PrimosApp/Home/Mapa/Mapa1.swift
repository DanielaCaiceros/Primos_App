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
    @State private var selectedArea: String = ""

    var body: some View {
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

                // EXPOSICIONES TEMPORALES
                Button(action: {
                    selectedArea = "Exposiciones temporales"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 150, height: 200)
                }
                .position(x: -290 * scale + offset.width + geometry.size.width / 2,
                          y: 40 * scale + offset.height + geometry.size.height / 2)
                
                // PERTENEZCO
                Button(action: {
                    selectedArea = "Pertenezco"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 450)
                }
                .position(x: -90 * scale + offset.width + geometry.size.width / 2,
                          y: -175 * scale + offset.height + geometry.size.height / 2)
                Button(action: {
                    selectedArea = "Pertenezco"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 200, height: 175)
                }
                .position(x: 100 * scale + offset.width + geometry.size.width / 2,
                          y: -335 * scale + offset.height + geometry.size.height / 2)
                
                //PEQUEÑOS
                Button(action: {
                    selectedArea = "Pequeños"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 200, height: 125)
                }
                .position(x: 225 * scale + offset.width + geometry.size.width / 2,
                          y: -185 * scale + offset.height + geometry.size.height / 2)
                
                //Comunico
                Button(action: {
                    selectedArea = "Comunico"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 275, height: 200)
                }
                .position(x: 185 * scale + offset.width + geometry.size.width / 2,
                          y: 15 * scale + offset.height + geometry.size.height / 2)
                
                //Tienda
                Button(action: {
                    selectedArea = "Pequeños"
                    isShowingPopover = true
                }) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 100, height: 175)
                }
                .position(x: -100 * scale + offset.width + geometry.size.width / 2,
                          y: 300 * scale + offset.height + geometry.size.height / 2)
                
            }

            .popover(isPresented: $isShowingPopover) {
                VStack {
                    Text("Información sobre \(selectedArea)")
                        .font(.headline)
                    Text("Descripción detallada del área seleccionada en Piso 2.")
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
        .navigationBarTitle("Mapa Planta Alta", displayMode: .inline)
    }
}

#Preview {
    Mapa1()
}
