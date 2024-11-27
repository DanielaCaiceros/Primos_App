//
//  ContentView.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView{
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                        .font(.caption)
                }
            QRScannerView()
                .tabItem {
                    Image(systemName: "qrcode")
                    Text("QR")
                        .font(.caption)
                }
            MiRuta()
                .tabItem {
                    Image(systemName: "point.bottomleft.forward.to.point.topright.scurvepath")
                    Text("Mi Ruta")
                        .font(.caption)
                }
            MapaSeleccion()
                .tabItem {
                    Image(systemName: "map.circle.fill")
                    Text("Mapa")
                        .font(.caption)
                }
        }
        .accentColor(Color(AppColors.verde))
    }
}

#Preview {
    ContentView()
}
