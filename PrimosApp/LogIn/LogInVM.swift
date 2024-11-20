//
//  LogInVM.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 14/11/24.
//

import SwiftUI
import CryptoKit
import FirebaseFirestore

class nuevoUsuarioModel : ObservableObject {
    @Published var nombre : String = ""
    @Published var correo : String = ""
    @Published var password : String = ""
    @Published var edad : Int = 0
    @Published var sal : String = ""
    @Published var registroExitoso: Bool = false
    @Published var errorMessage: String? = nil
    
    let db = Firestore.firestore()
    
    func postUsuario() async {
        do {
            // Llamar función de Sal
            sal = crearSal(longitud: 20)
            let encryptedPassword = encryptPassword(password: password, salt: sal)
            let usuario = nuevoUsuario(nombre: nombre, correo: correo, password: encryptedPassword, edad: edad, sal: sal)
            let _ = try db.collection("Usuario").addDocument(from: usuario)
            print("Nuevo usuario agregado")
        } catch {
            print("Error al crear usuario en BD: \(error.localizedDescription)")
        }
    }
    
    func crearSal(longitud: Int) -> String {
        let caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&*"
        
        return String((0..<longitud).compactMap { _ in caracteres.randomElement() })
    }
    
    func encryptPassword(password: String, salt: String) -> String {
        let saltedPassword = password + salt
        
        guard let saltedPasswordData = saltedPassword.data(using: .utf8) else {
            return ""
        }
        
        let hashedPassword = SHA256.hash(data: saltedPasswordData)
        let hashedPasswordString = hashedPassword.compactMap { String(format: "%02x", $0) }.joined()
        
        return hashedPasswordString
    }
    
}
