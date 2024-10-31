//
//  DetailedInfoView.swift
//  QRScanner
//
//  Created by Joirid Juarez Salinas on 28/10/24.
//

import SwiftUI

struct DetailedInfoView: View {
    var userID: String
    private let papaloteGreen : Color = Color.init(red: 0.745, green: 0.839, blue: 0.0)
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // Icono y logo
            Image("logo_papalote") // Agrega la imagen del logo
                .resizable()
                .scaledToFit()
                .frame(height: 100)

            // Título y descripción
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text("Aire")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(papaloteGreen)
                    Text("de Pertenezco")
                        .font(.title)
                        .foregroundColor(papaloteGreen)
                }
                Text("Introduce un pañuelo a los canales de aire, síguelo y cáchalo cuando este termine su recorrido")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            // Imagen de la exhibición
            Image("Aire_img") // Reemplaza con el nombre de la imagen
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
                .padding(.horizontal)

            Spacer()

            // Barra de navegación
            HStack {
                Image(systemName: "house")
                Spacer()
                Image(systemName: "qrcode")
                Spacer()
                Image(systemName: "point.bottomleft.forward.to.point.topright.scurvepath")
                Spacer()
                Image(systemName: "map.circle.fill")
            }
            .font(.title)
            .padding(.horizontal, 30)
            .foregroundColor(.gray)
        }
        .padding()
    }
}


#Preview {
    DetailedInfoView(userID: "userID")
}
