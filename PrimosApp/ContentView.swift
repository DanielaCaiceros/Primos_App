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
                }
            QRScannerView()
                .tabItem {
                    Image(systemName: "qrcode")
                }
            MiRuta()
                .tabItem {
                    Image(systemName: "point.bottomleft.forward.to.point.topright.scurvepath")
                }
            MapaSeleccion()
                .tabItem {
                    Image(systemName: "map.circle.fill")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    ContentView()
}
