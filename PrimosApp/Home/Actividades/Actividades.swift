//  Actividades.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import Foundation
import SwiftUI


struct Zona: Identifiable, Codable {
    var id: String
    var nombre: String
    var color: String
    var foto: String
    
}


struct Actividad: Identifiable, Codable {
    var id: String
    var nombre: String
    var descripcion: String
    var foto: String
    var calificacion: String
    var x: Int
    var y: Int
    var Piso: Int
    var tiempo: Int
    var disponibilidad: Bool
    var zonaId: String
}


