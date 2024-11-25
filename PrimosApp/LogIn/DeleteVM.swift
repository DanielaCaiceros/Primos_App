//
//  DeleteVM.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 22/11/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class DeleteVM : ObservableObject {
    @Published var correo : String = ""
    @Published var password : String = ""

    func deleteUser() {
        guard let user = Auth.auth().currentUser else {
            print("No hay un usuario autenticado.")
            return
        }
        
        // Reautenticación del usuario
        let credential = EmailAuthProvider.credential(withEmail: correo, password: password)
        user.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                print("Error al reautenticar: \(error.localizedDescription)")
                return
            }
            
            // Eliminar al usuario
            user.delete { error in
                if let error = error {
                    print("Error al eliminar usuario: \(error.localizedDescription)")
                } else {
                    print("Usuario eliminado exitosamente.")
                }
            }
        }
    }

}
