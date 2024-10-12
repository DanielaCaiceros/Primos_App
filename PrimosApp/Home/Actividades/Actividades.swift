//
//  Actividades.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import Foundation
import SwiftUI

/*struct Actividades: Identifiable, Codable {
    var id : Int
    var title: String = ""
    var description: String = ""
    var imageUrl: String = ""
    var category: String = "" 
}
*/

struct Actividad: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageUrl: String
    let imageTitle: String
    let color: Color
}
