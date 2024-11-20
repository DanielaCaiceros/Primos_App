//
//  LogInView.swift
//  PapaloteLogIn
//
//  Created by Joirid Juarez Salinas on 17/10/24.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var nuevoUsuarioVM = nuevoUsuarioModel()
    @State private var isPasswordVisible: Bool = false
    @State private var isChecked: Bool = false
    @State private var isSignInScreen: Bool = false
    @State private var nameError : String?
    @State private var mailError : String?
    @State private var passwordError : String?
    @State private var adviceMessage: String?
    @State private var someError : Bool = false
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Color.init(red: 0.745, green: 0.839, blue: 0.0)
                .ignoresSafeArea()
            VStack {
                HStack{
                    Button{
                        // Cambiar idioma
                    } label: {
                        Image(systemName: "translate")
                            .imageScale(.large)
                            .foregroundStyle(AppColors.morado)
                    }
                    .padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.08)

        ZStack {
            VStack{
                VStack {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                }
                .padding(.bottom, 8)
                
                VStack (alignment: .leading) {
                    Text("Nombre")
                        .font(.title3)
                    TextField("Nombre", text: $nuevoUsuarioVM.nombre)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(nameError == nil ? Color.clear : Color.red, lineWidth: 1)
                        )
                        .padding(.bottom, 8)
                    
                    // Si existe, mostrar un error en el nombre
                    if let eName = nameError {
                        Text(eName)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                    }

                    Text("Correo")
                        .font(.title3)
                    TextField("correo@example.com", text: $nuevoUsuarioVM.correo)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(mailError == nil ? Color.clear : Color.red, lineWidth: 1)
                        )
                        .padding(.bottom, 8)
                    
                    // Si existe, mostrar un error en el correo
                    if let eMail = mailError {
                        Text(eMail)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                    }
                    
                    Text("Contraseña")
                        .font(.title3)
                    HStack{
                        if isPasswordVisible {
                            TextField("", text: $nuevoUsuarioVM.password)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .autocorrectionDisabled()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(passwordError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                            
                        } else {
                            SecureField("12345", text: $nuevoUsuarioVM.password)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .autocorrectionDisabled()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(passwordError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                        }
                        
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(AppColors.morado)
                        }
                    }
                    .padding(.bottom, 8)
                    
                    // Si existe, mostrar un error en la contraseña
                    if let ePass = passwordError {
                        Text(ePass)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                    }
                    
                    Text("Edad de los visitantes:")
                        .font(.title3)
                    TextField("Ingresa la edad", value: $nuevoUsuarioVM.edad, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .keyboardType(.numberPad)
                }.padding()
                
                VStack {
                    Toggle(isOn:$isChecked) {
                        Text("Acepto que se recopilen datos de mi visita para mejorar la experiencia.")
                            .font(.headline)
                    }.toggleStyle(CheckboxToggleStyle())
                }.padding(.all, 8)
                
                // Si existe, mostrar un error para el aviso de recopilación de datos
                if let advice = adviceMessage {
                    Text(advice)
                        .foregroundColor(.red) // Color del texto del error
                        .font(.caption) // Tamaño pequeño para el mensaje
                }
                
                VStack {
                    Button {
                        // Enviar los datos de registro a la BD
                        validatePostUser()
                    } label: {
                        Text("Registrarme")
                            .padding()
                            .font(.title3)
                            .bold()
                            .foregroundStyle(AppColors.morado)
                            .background(AppColors.verde)
                            .cornerRadius(10)
                    }
                }.padding()
                
                HStack {
                    Button {
                        isSignInScreen = true
                    } label : {
                        Text("¿Ya tienes cuenta?")
                            .font(.title2)
                            .foregroundStyle(AppColors.morado)
                    }
                    .fullScreenCover(isPresented: $isSignInScreen) {
                        SignInView()
                    }
                }
            }
            .padding(.bottom, 25)
                    
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.88)
    }
    
    private func validatePostUser() {
        someError = false
        
        if nuevoUsuarioVM.nombre.isEmpty {
            nameError = "Este campo no puede estar vacío."
            someError = true
        } else {
            nameError = nil
        }
        if nuevoUsuarioVM.correo.isEmpty {
            mailError = "Este campo no puede estar vacío."
            someError = true
        } else {
            mailError = nil
        }
        if nuevoUsuarioVM.password.isEmpty{
            passwordError = "Este campo no puede estar vacío."
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
                await nuevoUsuarioVM.postUsuario()
            }
            
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
    
}


#Preview {
    LogInView()
}
