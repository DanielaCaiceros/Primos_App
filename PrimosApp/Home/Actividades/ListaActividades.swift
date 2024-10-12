//
//  ListaActividades.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI

/*class ActividadesModelo: ObservableObject {
    @Published var actividades: [Actividades] = []
    
    func fetchActivities() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Post].self, from: data)
                    let actividades = decodedData.map { post in
                        Actividades(id: post.id,  description: post.body)
                    }
                    DispatchQueue.main.async {
                        self.actividades = actividades
                    }
                } catch {
                    print("Error al decodificar los datos: \(error)")
                }
            }
        }.resume()
    }
}

struct Post: Codable {
    var id: Int
    var title: String
    var body: String
}*/
