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
    @Published var actividadesRuta: [Actividad] = [] 
    
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
                if disponibilidad == true {
                    arrActividades.append(actividad)
                }
            }
           self.actividades = arrActividades
        
        } catch {
            print("Error al obtener actividades: \(error.localizedDescription)")
        }
    }

    func getActividadesRuta(id_usuario: String) async {
        do {
            // 1. Obtener los documentos de "Mi_ruta"
            let querySnapshot = try await db.collection("Mi_ruta").getDocuments()
            print("Documentos de Mi_ruta obtenidos: \(querySnapshot.documents.count)")
            
            // 2. Crear el arreglo arrAct con los documentID de "Mi_ruta"
            let arrAct: [String] = querySnapshot.documents.compactMap { document in
                guard let data = document.data() as? [String: Any],
                      let idActividad = data["id_actividad"] as? String,
                      let idUsuario = data["id_usuario"] as? String
                else {
                    return ""
                }
                if idUsuario == id_usuario {
                        return idActividad
                    } else {
                        return nil
                    }
            }
            
            print("IDs de actividades: \(arrAct)")
            // 3. Realizar una consulta de "Actividad" con los documentIDs obtenidos
            let queryAct = try await db.collection("Actividad").getDocuments()
            
            var listRuta: [Actividad] = []
            
            for actividad in arrAct {
                for documents in queryAct.documents{
                    if (actividad == documents.documentID) {
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
    
    func agregarARuta(id_usuario: String, id_actividad: String, calificacion: Float) async {
        
        var aparece = false
        do{
            let docRef = try await db.collection("Mi_ruta").getDocuments()
            for document in docRef.documents {
                let data = document.data()
                if id_usuario == data["id_usuario"] as? String ?? "Logo" && id_actividad == data["id_actividad"] as? String ?? "Logo" {
                    print("Ya existe documento")
                    aparece = true
                }
            }
            if aparece == false {
                let nue = nuevaActividadRuta(id_usuario: id_usuario, id_actividad: id_actividad, calificacion: calificacion )
                let _ = try db.collection("Mi_ruta").addDocument(from: nue)
            }
        } catch {
            print("Error al subir a Mi_ruta: \(error.localizedDescription)")
        }
    }
    
    func calificarActividad(id_usuario: String, id_actividad: String, calificacion: Float) async {
        do {
            let docRef = try await db.collection("Mi_ruta").getDocuments()
            
            for document in docRef.documents {
                let data = document.data()
                if id_usuario == data["id_usuario"] as? String ?? "Logo" && id_actividad == data["id_actividad"] as? String ?? "Logo" {
                    
                    let userRef = db.collection("Mi_ruta").document(document.documentID)
                    do {
                        try await userRef.updateData(["calificacion": calificacion])
                        print("Se actualizó")
                    } catch {
                        print("ERROR")
                    }
                }
            }
            await self.actualizarCal(id_actividad: id_actividad)
            
        } catch {
            print("Error al cargar mi ruta: \(error.localizedDescription)")
        }
    }
    
    func actualizarCal(id_actividad: String) async {
        var sum = 0
        var num = 0
        do {
            //CALCULAR
            let querySnapshot = try await db.collection("Mi_ruta").whereField("id_actividad", isEqualTo: id_actividad).getDocuments()
            
            for doc in querySnapshot.documents {
                let data = doc.data()
                var cal = data["calificacion"]as? Int ?? 0
                if cal != 0 {
                    sum = sum + cal
                    num += 1
                }
            }
            var cal = sum/num
            
            //ACTUALIZAR
            let userRef = db.collection("Actividad").document(id_actividad)
            do {
                try await userRef.updateData(["calificacion": cal])
                print("Se actualizó calificación en Actividad")
            } catch {
                print("ERROR")
            }
            
        } catch {
            
        }
    }
    
    func getColor(id_zona: String) async -> String {
        var color:  String = ""
        do {
            let querySnapshot = try await db.collection("Zona").whereField("id_zona", isEqualTo: id_zona).getDocuments()
            
            for document in querySnapshot.documents {
                let data = document.data()
                color = data["color"] as? String ?? "#FFFFFF"
            }
        } catch {
            print("ERROR al obtener color")
        }
        return color
    }
    
}

