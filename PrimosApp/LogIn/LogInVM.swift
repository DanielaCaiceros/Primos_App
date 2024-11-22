//
//  LogInVM.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 14/11/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class LogInVM : ObservableObject {
    @Published var nombre : String = ""
    @Published var correo : String = ""
    @Published var password : String = ""
    @Published var edad : Int = 0
    @Published var nameError : String?
    @Published var mailError : String?
    @Published var passwordError : String?
    @Published var adviceMessage: String?
    @Published var isPasswordVisible: Bool = false
    @Published var isSignInScreen: Bool = false
    @Published var isChecked: Bool = false
    @Published var someError : Bool = false
    @Published var logged : Bool = false
    @Published var newError: String?
    
    private let db = Firestore.firestore()
    
    func validarDatos() async {
        someError = false
        
        if nombre.isEmpty {
            nameError = "Este campo no puede estar vacío."
            someError = true
        } else {
            nameError = nil
        }
        
        if correo.isEmpty || !correoValido(correo) {
            mailError = correo.isEmpty ? "Este campo no puede estar vacío." : "El correo no tiene un formato válido."
            someError = true
        } else {
            mailError = nil
        }
        
        if password.isEmpty || password.count < 6 {
            passwordError = password.isEmpty ? "Este campo no puede estar vacío." : "La contraseña debe tener al menos 6 caracteres."
            someError = true
        } else {
            passwordError = nil
        }
        
        if !isChecked {
            someError = true
            adviceMessage = "Es necesario aceptar el aviso de recopilación de datos."
        } else {
            adviceMessage = nil
        }
        
        // Si no hay nigún error guardar usuario en BD
        if !someError {
            Task {
                await registrarUsuario()
            }
        }
    }
    
    func registrarUsuario() async {
        do {
            let authResult = try await FirebaseAuth.Auth.auth().createUser(withEmail: correo, password: password)
            let uid = authResult.user.uid
            print("Usuario creado exitosamente. UID: \(uid)")
            await agregarDatosUsuario(uid: uid)
        } catch let authError as NSError {
            await MainActor.run {
                self.newError = manejoErroresFirebase(authError)
            }
        }
    }
    
    func agregarDatosUsuario(uid : String) async {
        do {
            let usuario = UsuarioNuevo(nombre: nombre, edad: edad)
            try db.collection("Usuario").document(uid).setData(from: usuario)
            print("Nuevo usuario agregado")
            await MainActor.run {
                self.logged = true
            }
        } catch {
            await MainActor.run {
                self.newError = "Error al guardar los datos del usuario: \(error.localizedDescription)"
            }
        }
    }
    
    
    
    private func manejoErroresFirebase(_ error: NSError) -> String {
            switch error.code {
            case AuthErrorCode.invalidEmail.rawValue:
                return "El correo no tiene el formato correcto."
            case AuthErrorCode.weakPassword.rawValue:
                return "La contraseña debe tener al menos 6 caracteres."
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "El correo ya está en uso."
            default:
                return "Error al registrar el usuario: \(error.localizedDescription)"
            }
        }
}

func correoValido(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
