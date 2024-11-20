//
//  Usuario.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 14/11/24.
//

import Foundation
import SwiftUI

struct Usuario : Identifiable, Codable {
    var id : String
    var nombre : String
    var correo : String
    var password : String
    var edad : Int
    var sal : String
    var fecha_creacion : Date
}

struct nuevoUsuario : Codable {
    var password : String
    var edad : Int
    var correo : String
    var fecha_creacion : Date
    var nombre : String
    var sal : String
    
    init(nombre: String, correo: String, password: String, edad : Int, sal: String) {
        self.password = password
        self.edad = edad
        self.correo = correo
        self.fecha_creacion = Date()
        self.nombre = nombre
        self.sal = sal
    }
}
