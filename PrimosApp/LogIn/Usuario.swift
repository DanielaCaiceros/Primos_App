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
}
