//  ActividadesView.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import FirebaseAuth
import SwiftUI

struct ActividadesView: View {
    @StateObject var actividadesModelo: ActividadesModelo
    @State private var uid: String = ""
    @State private var isShowingToast = true
    @State private var textoBoton = "Añadir a mi ruta"
    
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
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 125)
                                .cornerRadius(20)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 125, height: 75)
                                .cornerRadius(20)
                                .clipped()
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
                                        .cornerRadius(13)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(13)
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
                                    Task {
                                        await
                                        actividadesModelo.agregarARuta(id_usuario: uid, id_actividad: actividad.id, calificacion: 0.0)
                                    }
                                    textoBoton = "✔︎ Agregado a tu ruta"
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                        Text(textoBoton)
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
            fetchCurrentUserUID()
            Task {
                await actividadesModelo.getActividadesPorZona(zonaId: zona.id)
            }
        }
    }
    func fetchCurrentUserUID(){
        if let user = Auth.auth().currentUser {
            uid=user.uid
        } else {
            uid = ""
        }
    }
}


