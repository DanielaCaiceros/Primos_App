//  Home.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//


import SwiftUI

struct Home: View {
    @StateObject private var actividadesModelo = ActividadesModelo()
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo en la parte superior
                Image("logo_verde") // Asegúrate de que el nombre de la imagen coincida con el asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.top, 20)
                
                Text("¿Qué quieres ver en el museo?")
                    .font(.title3)
                    .padding(.bottom, 20)
                
                // Mostrar las zonas o mensaje de carga
                if !actividadesModelo.zonas.isEmpty {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(actividadesModelo.zonas, id: \.id) { zona in
                                NavigationLink(destination: ActividadesView(actividadesModelo: actividadesModelo, zona: zona)) {
                                    HStack {
                                        Image(zona.foto) // Imagen de la zona desde los assets
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                            .padding()
                                        
                                        Text(zona.nombre)
                                            .font(.title3)
                                            .foregroundColor(Color(hex: zona.color)) // Convierte el color hexadecimal
                                            .padding()
                                    }
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    ProgressView("Cargando zonas...")
                        .padding()
                }
            }
            .navigationTitle("Zonas")
            .onAppear {
                Task {
                    await actividadesModelo.getZonas()
                }
            }
        }
    }
}
extension Color {
    init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexSanitized)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let red = Double((color & 0xFF0000) >> 16) / 255.0
        let green = Double((color & 0x00FF00) >> 8) / 255.0
        let blue = Double(color & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    Home()
}
