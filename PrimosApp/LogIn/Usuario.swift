//
//  Usuario.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 14/11/24.
//

import Foundation
import SwiftUI

struct Usuario : Identifiable, Codable {
    var id : String     // ID de usuario que se autentificó
    var nombre : String
    var edad : Int
    var fecha_creacion : Date
}

struct UsuarioNuevo : Codable {
    var nombre : String
    var edad : Int
    var fecha_creacion : Date
    
    init(nombre: String, edad : Int) {
        self.nombre = nombre
        self.edad = edad
        self.fecha_creacion = Date()
    }
}
