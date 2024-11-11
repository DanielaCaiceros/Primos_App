
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
        List {
            ForEach(actividadesModelo.actividades.filter { $0.zonaId == zona.id }, id: \.id) { actividad in
                HStack {
                    Text(actividad.nombre)
                    Spacer()
                    Text(actividad.calificacion)
                }
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


