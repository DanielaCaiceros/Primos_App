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

struct nuevaActividadRuta : Codable {
    var id_usuario : String
    var id_actividad : String
    var calificacion : Float
    
    init(id_usuario: String, id_actividad: String, calificacion : Float) {
        self.id_usuario = id_usuario
        self.id_actividad = id_actividad
        self.calificacion = calificacion
    }
}

