//
//  IMAXModel.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 20/11/24.
//

import Foundation
import FirebaseFirestore

class IMAXModel: ObservableObject {
    @Published var imaxItems: [IMAX] = []
    
    let db = Firestore.firestore()
    
    func getIMAX() async {
        do {
            let querySnapshot = try await db.collection("IMAX").getDocuments()
            var arrIMAX: [IMAX] = []
            
            for document in querySnapshot.documents {
                let data = document.data()
                let descripcion = data["Descripción"] as? String ?? "-"
                let horarios = data["Horarios"] as? String ?? "-"
                let imagen = data["Imagen"] as? String ?? "-"
                let nombre = data["Nombre"] as? String ?? "-"
                let tipo = data["Tipo"] as? String ?? "-"
                let id = document.documentID
                
                let imax = IMAX(id: id, descripcion: descripcion, horarios: horarios, imagen: imagen, nombre: nombre, tipo: tipo)
                arrIMAX.append(imax)
            }
            
            self.imaxItems = arrIMAX
        } catch {
            print("Error al obtener los elementos IMAX: \(error.localizedDescription)")
        }
    }
}
