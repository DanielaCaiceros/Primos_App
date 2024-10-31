//
//  Home.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        NavigationView {
            VStack{
                Image(Logos.logo_verde)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                Text("¿Qué quieres ver en el museo?")
                    .font(.title3)
                
                HStack {
                    NavigationLink(destination: ActividadesView(title: "Pertenezco", description: "Descripción de Pertenezco", imageTitle: Logos.pertenezcoLogo, color: AppColors.verde)) {
                        Image(Logos.pertenezcoLogo)
                            .padding()
                    }
                    
                    NavigationLink(destination: ActividadesView(title: "Comunico", description: "Descripción de Comunico", imageTitle: Logos.comunicoLogo, color: AppColors.azul)) {
                        Image(Logos.comunicoLogo)
                            .padding()
                    }
                }
                
                HStack {
                    NavigationLink(destination: ActividadesView(title: "Expresso", description: "Descripción de Expersso", imageTitle: Logos.expressoLogo, color: AppColors.naranja)) {
                        Image(Logos.expressoLogo)
                            .padding()
                    }
                    
                    NavigationLink(destination: ActividadesView(title: "Soy", description: "Descripción de Soy", imageTitle: Logos.soyLogo, color: AppColors.rojo)) {
                        Image(Logos.soyLogo)
                            .padding()
                    }
                }
                
                HStack {
                    NavigationLink(destination: ActividadesView(title: "Comprendo", description: "Descripción de Comprendo", imageTitle: Logos.comprendoLogo, color: AppColors.morado)) {
                        Image(Logos.comprendoLogo)
                            .padding()
                    }
                    
                    NavigationLink(destination: ActividadesView(title: "Pequeños", description: "Descripción de Pequeños", imageTitle: Logos.pequeñosLogo, color: AppColors.verde)) {
                        Image(Logos.pequeñosLogo)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    Home()
}
