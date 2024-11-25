//
//  SignInVM.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 19/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class SignInVM : ObservableObject {
    @Published var correo : String = ""
    @Published var password : String = ""
    @Published var errorMessage: String? = nil
    @Published var mailError : String?
    @Published var passwordError : String?
    @Published var someError : Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var isLogInScreen: Bool  = false
    @Published var logged: Bool = false
    
    func validarDatosSignIn() async {
        someError = false
        
        if correo.isEmpty || !correoValido(correo) {
            mailError = correo.isEmpty ? "Este campo no puede estar vacío." : "El formato del correo no es válido."
            someError = true
        } else {
            mailError = nil
        }
        
        if password.isEmpty{
            passwordError = password.isEmpty ? "Este campo no puede estar vacío." : "La contraseña debe tener al menos 6 caracteres."
            someError = true
        } else {
            passwordError = nil
        }
        
        // Si no hay nigún error -> autenticar usuario
        if !someError {
            Task {
                await autenticarUsuario()
            }
        }

    }
    
    func autenticarUsuario() async {
        do {
            let authResult = try await FirebaseAuth.Auth.auth().signIn(withEmail: correo, password: password)
            let uid = authResult.user.uid
            print("Inicio de sesión exitoso. UID: \(uid)")
            
            // Actualizar el estado para la UI
            await MainActor.run {
                self.logged = true
                self.errorMessage = nil
            }
        } catch let authError as NSError {
            await MainActor.run {
                self.errorMessage = self.manejoErroresFirebase(authError)
                print(self.errorMessage ?? " ")
            }
        }
    }
    
    private func manejoErroresFirebase(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return "La contraseña es incorrecta."
        case AuthErrorCode.invalidEmail.rawValue:
            return "El formato del correo no es válido."
        case AuthErrorCode.userNotFound.rawValue:
            return "No se encontró una cuenta con este correo."
        case AuthErrorCode.invalidCredential.rawValue:
            return "Las credenciales proporcionadas son incorrectas."
        default:
            return "Error al iniciar sesión: \(error.localizedDescription)"
        }
    }
}
