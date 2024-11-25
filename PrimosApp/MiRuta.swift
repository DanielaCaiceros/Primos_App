//
//  MiRuta.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI
import FirebaseAuth

struct MiRuta: View {
    @StateObject private var actividadesModel = ActividadesModelo()
    @State private var uid:String = ""
    
    var body: some View {
        NavigationView{
        VStack{
            ZStack{
                Color(hex: "#C6D444")
                VStack{
                    Image(Logos.mariposa)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text("Mi ruta")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(2)
                }
            }
            .frame(maxHeight: 200)
            ScrollView{
                VStack{
                    if !actividadesModel.actividadesRuta.isEmpty {
                        VStack{
                            ForEach(actividadesModel.actividadesRuta, id: \.id) { actividad in
                                RutaView(actividadesModelo: actividadesModel, actividad: actividad)
                            }
                        }
                    } else {
                        ProgressView("Cargando tu ruta...")
                            .padding()
                    }
                }
                .padding()
            }
            }
            .onAppear {
                Task {
                    await actividadesModel.getActividadesRuta(id_usuario: uid)
                }
            }
        }
        }
    func fetchCurrentUserUID(){
        if let user = Auth.auth().currentUser {
            uid = user.uid
        } else {
            uid = ""
        }
    }
}



#Preview {
    MiRuta()
}

