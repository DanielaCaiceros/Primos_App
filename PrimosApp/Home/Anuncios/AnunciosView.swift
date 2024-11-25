//
//  AnunciosView.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 13/11/24.
//

import SwiftUI

struct AnunciosView: View {
    @StateObject var anunciosModel = AnunciosModel()
    @StateObject var imaxModel = IMAXModel()
    
    var body: some View {
        VStack {
            ZStack {
                Color.gray.opacity(0.1)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 75)
                
                HStack {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                    
                    Text("Anuncios")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
            }
            
            // Contenedor para los anuncios de IMAX
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("IMAX")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(imaxModel.imaxItems) { imax in
                        HStack(alignment: .top, spacing: 15) {
                            Image(imax.imagen) // Imagen del IMAX
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 150)
                                .clipped()
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(imax.nombre)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text(imax.tipo)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                
                                Text(imax.descripcion)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text(imax.horarios)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Separador
                    Divider()
                        .padding(.vertical)
                    
                    // Contenedor para otros anuncios
                    Text("Anuncios")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(anunciosModel.Anuncio) { anuncio in
                        HStack(alignment: .top, spacing: 15) {
                            Image(anuncio.imagen)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(anuncio.nombre)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text(anuncio.anuncio)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await anunciosModel.getAnuncios()
                await imaxModel.getIMAX()
            }
        }
    }
}
