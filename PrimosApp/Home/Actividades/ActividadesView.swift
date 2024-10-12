//
//  ActividadesView.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI

struct ActividadesView: View {
    var title: String = ""
    var description: String 
    var imageUrl: String = ""
    var imageTitle: String
    var color: Color
    var body: some View {
        VStack {
            ZStack {
                color.ignoresSafeArea()
                    .frame(height: 150)
                Image(imageTitle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack(alignment: .top, spacing: 16) {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text(title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(color)

                            Text(description)
                                .font(.body)
                                .foregroundColor(.gray)

                            Button(action: {
                                // Acción al presionar el botón
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text("Añadir a mi ruta")
                                }
                                .padding(8)
                                .background(color)
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
                .padding()
            }
        }
    }
}
