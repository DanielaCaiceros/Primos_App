//
//  ListaActView.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 25/11/24.
//

import SwiftUI

struct ListaActividades: View {
    let zona: Zona
    @ObservedObject var actividadesModelo: ActividadesModelo
    
    var body: some View {
        VStack {
            Text("Actividades en \(zona.nombre)")
                .font(.largeTitle)
                .padding()
            
            if actividadesModelo.actividades.isEmpty {
                Text("Cargando actividades...")
                    .padding()
            } else {
                List(actividadesModelo.actividades.filter { $0.zonaId == zona.id }) { actividad in
                    HStack {
                        Image(actividad.foto)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(actividad.nombre)
                                .font(.headline)
                            Text(actividad.descripcion)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await actividadesModelo.getActividadesPorZona(zonaId: zona.id)
            }
        }
    }
}
