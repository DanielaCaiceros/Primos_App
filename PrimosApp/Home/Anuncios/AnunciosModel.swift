//
//  AnunciosModel.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 19/11/24.
//

import FirebaseFirestore

class AnunciosModel : ObservableObject {
    @Published var Anuncio: [Anuncios]=[]
    
    let db = Firestore.firestore()
    
    func getAnuncios() async {
        do {
            let querySnapshot = try await db.collection("Anuncio").getDocuments()
            var arrAnuncios: [Anuncios] = [] // Cambié let por var para poder modificar el array
            
            for document in querySnapshot.documents {
                let data = document.data()
                let anuncio = data["Anuncio"] as? String ?? "-"
                let imagen = data["Imagen"] as? String ?? "-"
                let nombre = data["Nombre"] as? String ?? "-"
                let id = document.documentID
                
                let anuncios = Anuncios(id: id, anuncio: anuncio, imagen: imagen, nombre: nombre)
                arrAnuncios.append(anuncios)
            }
            self.Anuncio = arrAnuncios 
        } catch {
            print("Error al obtener los anuncios: \(error.localizedDescription)")
        }
    }
}
