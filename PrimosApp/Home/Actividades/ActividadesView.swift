
//  ActividadesView.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//


import SwiftUI

struct ActividadesView: View {
    @StateObject var actividadesModelo: ActividadesModelo
    var zona: Zona
    
    var body: some View {
        VStack {
            ZStack {
                Color(hex: zona.color)
                    .ignoresSafeArea()
                    .frame(height: 150)
                
                if let url = URL(string: zona.foto) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
            }
                        ScrollView {
                VStack(spacing: 20) {
                    ForEach(actividadesModelo.actividades.filter { $0.zonaId == zona.id }, id: \.id) { actividad in
                        HStack(alignment: .top, spacing: 16) {
                            if let url = URL(string: actividad.foto) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                    .foregroundColor(.gray)
                            }
                            
                            // Información de la actividad
                            VStack(alignment: .leading, spacing: 8) {
                                Text(actividad.nombre)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: zona.color))
                                
                                Text(actividad.descripcion)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                    // Acción al presionar el botón
                                    print("Añadir a mi ruta presionado")
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                        Text("Añadir a mi ruta")
                                    }
                                    .padding(8)
                                    .background(Color(hex: zona.color))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(zona.nombre)
        .onAppear {
            Task {
                await actividadesModelo.getActividadesPorZona(zonaId: zona.id)
            }
        }
    }
}
