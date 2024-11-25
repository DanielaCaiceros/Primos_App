//
//  Anuncios.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 19/11/24.
//

import Foundation
import SwiftUI


struct Anuncios: Identifiable, Codable {
    var id: String
    var anuncio: String
    var imagen: String
    var nombre: String
    
}

struct IMAX : Identifiable, Codable{
    var id: String
    var descripcion: String
    var horarios: String
    var imagen: String
    var nombre: String
    var tipo: String
}
