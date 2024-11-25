//
//  DetailedInfoVM.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 24/11/24.
//

import SwiftUI
import FirebaseFirestore

class DetailedInfoVM : ObservableObject {
    @Published var actividadID : String = ""
    @Published var nombreActividad : String = ""
    @Published var descripcion_qr : String = ""
    @Published var foto : String = ""
    
    private let db = Firestore.firestore()
    
    func getDetallesActividad() async {
        do {
            let documentRef = db.collection("Actividad").document(actividadID)
            let document = try await documentRef.getDocument()
            
            if let data = document.data() {
                DispatchQueue.main.async {
                    self.nombreActividad = data["nombre"] as? String ?? "-"
                    self.descripcion_qr = data["descripcion_qr"] as? String ?? "-"
                    self.foto = data["foto"] as? String ?? "-"
                }
            } else {
                print("Documento no encontrado.")
            }
        } catch {
            print("Error al obtener la actividad: \(error.localizedDescription)")
        }
    }
}
