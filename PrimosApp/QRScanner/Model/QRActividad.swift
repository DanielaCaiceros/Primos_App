//
//  QRActividad.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 24/11/24.
//

import SwiftUI

struct QRActividad : Identifiable, Codable {
    var id : String     // ID de usuario que se autentificó
    var nombre : String
    var descripcion_qr : String
    var foto : String
}
