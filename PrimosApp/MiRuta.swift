//
//  MiRuta.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI

struct MiRuta: View {
    @StateObject private var actividadesModel = ActividadesModelo()
    
    var body: some View {
        NavigationView{
            VStack{
                
                if !actividadesModel.actividadesRuta.isEmpty {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                            ForEach(actividadesModel.actividadesRuta.prefix(2), id: \.id) { actividad in
                            NavigationLink("hola") {
                            Rutaview(actividadesModelo: actividadesModel, actividad: actividad)
                            }
                        }
                        
                    }
                    .padding()
                } else {
                    ProgressView("Cargando tu ruta...")
                        .padding()
                }
            }
            .onAppear {
                Task {
                    await actividadesModel.getActividadesRuta()
                }
            }
        }

    }
}


#Preview {
    MiRuta()
}
