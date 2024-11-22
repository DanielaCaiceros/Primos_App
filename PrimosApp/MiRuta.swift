//
//  RutaView.swift
//  PrimosApp
//
//  Created by Alumno on 19/11/24.
//

import SwiftUI
import FirebaseAuth


struct RutaView: View {
    @StateObject var actividadesModelo: ActividadesModelo
    @State private var rating = 0
    @State private var uid: String? = nil
    var actividad: Actividad
    var body: some View {
        
        HStack{
            if let url = URL (string: actividad.foto) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                    .frame(width: 100, height: 100)}
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                .foregroundColor(.gray)}
            VStack(alignment: .leading){
                Text(actividad.nombre)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(3)
                
                Text(actividad.descripcion)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                HStack{
                    ForEach(1..<6) { index in
                        Image(systemName: rating >= index ? "star.fill" : "star")
                            .foregroundColor(rating >= index ? Color(hex: "#C6D444") : .gray)
                            .padding(.top, 5)
                            .onTapGesture {
                                rating = index
                                Task {
                                    await                        actividadesModelo.calificarActividad(id_usuario: uid ?? "SIN USUARIO", id_actividad: actividad.id, calificacion: Float(rating))
                                }
                            }
                    }
                }
            }
            .padding(12)
            
        }
        .onAppear {
                   fetchCurrentUserUID()
        }
    }
    
    func fetchCurrentUserUID() {
            if let user = Auth.auth().currentUser {
                uid = user.uid
            } else {
                uid = nil // Usuario no autenticado
            }
    }
}

#Preview {
    MiRuta()
}

