//
//  DetailedInfoView.swift
//  QRScanner
//
//  Created by Joirid Juarez Salinas on 28/10/24.
//

import SwiftUI

struct DetailedInfoView: View {
    @Environment(\.dismiss) var dismiss
    var id: String
    @StateObject private var DetailInfoModel = DetailedInfoVM()
    
    // private let papaloteGreen : Color = Color.init(red: 0.745, green: 0.839, blue: 0.0)
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button {
                    dismiss() // Despedir la vista
                } label: {
                    Image(systemName: "xmark") // Icono de la "tachita"
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            Spacer()
        
            // Icono y logo
            Image("logo_papalote") // Agrega la imagen del logo
                .resizable()
                .scaledToFit()
                .frame(height: 100)

            // Título y descripción
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text(DetailInfoModel.nombreActividad)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(AppColors.verde)
                }
                Text(DetailInfoModel.descripcion_qr)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            if let url = URL(string: DetailInfoModel.foto) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .padding(.horizontal)
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            // Barra de navegación
        }
        .padding()
        .onAppear {
            DetailInfoModel.actividadID = id
            Task {
                await DetailInfoModel.getDetallesActividad()
            }
        }
    }
}


#Preview {
    DetailedInfoView(id: "actividadID")
}
