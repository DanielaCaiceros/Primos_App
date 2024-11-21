//
//  ListaActividades.swift
//  PrimosApp
//
//  Created by Daniela Caiceros on 12/10/24.
//

import SwiftUI
import FirebaseFirestore

class ActividadesModelo: ObservableObject {
    @Published var zonas: [Zona] = []
    @Published var actividades: [Actividad] = []
    
    let db = Firestore.firestore()
    
    // Obtener zonas desde Firebase
    func getZonas() async {
        do {
            let querySnapshot = try await db.collection("Zona").getDocuments()
            var arrZonas: [Zona] = []
            
            for document in querySnapshot.documents {
                let data = document.data()
                let nombre = data["nombre"] as? String ?? "-"
                let color = data["color"] as? String ?? "#FFFFFF"
                let foto = data["foto"] as? String ?? "Logo"
                let id = document.documentID
 
                
                let zona = Zona(id: id, nombre: nombre, color: color, foto: foto)
                arrZonas.append(zona)
            }
            self.zonas = arrZonas
            
        } catch {
            print("Error al obtener zonas: \(error.localizedDescription)")
        }
    }
    
    func getActividadesPorZona(zonaId: String) async {
        do {
            let querySnapshot = try await db.collection("Actividad").whereField("id_zona", isEqualTo: zonaId).getDocuments()
            var arrActividades: [Actividad] = []
            
            for document in querySnapshot.documents {
                let data = document.data()
                let nombre = data["nombre"] as? String ?? "-"
                let descripcion = data["descripcion"] as? String ?? "-"
                let foto = data["foto"] as? String ?? "-"
                let calificacion = data["calificacion"] as? String ?? "-"
                let x = data["x"] as? Int ?? 0
                let y = data["y"] as? Int ?? 0
                let Piso = data["z"] as? Int ?? 0
                let tiempo = data["tiempo"] as? Int ?? 0
                let disponibilidad = data["disponibilidad"] as? Bool ?? false
                let id = document.documentID
                
                let zonaId = data["id_zona"] as? String ?? ""

                let actividad = Actividad(id: id, nombre: nombre, descripcion: descripcion, foto: foto, calificacion: calificacion, x: x, y: y, Piso: Piso, tiempo: tiempo, disponibilidad: disponibilidad, zonaId: zonaId)
                arrActividades.append(actividad)
            }
           self.actividades = arrActividades
        
        } catch {
            print("Error al obtener actividades: \(error.localizedDescription)")
        }
    }

    func getActividadesRuta() async {
        do {
            // 1. Obtener los documentos de "Mi_ruta"
            let querySnapshot = try await db.collection("Mi_ruta").getDocuments()
            print("Documentos de Mi_ruta obtenidos: \(querySnapshot.documents.count)")
            
            // 2. Crear el arreglo arrAct con los documentID de "Mi_ruta"
            let arrAct: [String] = querySnapshot.documents.compactMap { document in
                guard let data = document.data() as? [String: Any],
                      let idActividad = data["id_actividad"] as? String else {
                    return nil
                }
                return idActividad
            }
            print("IDs de actividades: \(arrAct)")
            // 3. Realizar una consulta de "Actividad" con los documentIDs obtenidos
            let queryAct = try await db.collection("Actividad").getDocuments()
            
            var listRuta: [Actividad] = []
            
            for actividad in arrAct {
                for documents in queryAct.documents{
                    if actividad == documents.documentID {
                        let data = documents.data()
                        let nombre = data["nombre"] as? String ?? "-"
                        let descripcion = data["descripcion"] as? String ?? "-"
                        let foto = data["foto"] as? String ?? "-"
                        let calificacion = data["calificacion"] as? String ?? "-"
                        let x = data["x"] as? Int ?? 0
                        let y = data["y"] as? Int ?? 0
                        let Piso = data["z"] as? Int ?? 0
                        let tiempo = data["tiempo"] as? Int ?? 0
                        let disponibilidad = data["disponibilidad"] as? Bool ?? false
                        let id = documents.documentID
                        let zonaId = data["id_zona"] as? String ?? "-"
                        
                        let actividad = Actividad(id: id, nombre: nombre, descripcion: descripcion, foto: foto, calificacion: calificacion, x: x, y: y, Piso: Piso, tiempo: tiempo, disponibilidad: disponibilidad, zonaId: zonaId)
                        listRuta.append(actividad)
                    }
                }
            }

            self.actividadesRuta = listRuta
            print("Actividades de la ruta cargadas: \(self.actividadesRuta.count)")
        } catch {
            print("Error al obtener actividades de la ruta: \(error.localizedDescription)")
        }
        
    }
    
}
