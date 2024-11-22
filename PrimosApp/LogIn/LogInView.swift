//
//  LogInView.swift
//  PapaloteLogIn
//
//  Created by Joirid Juarez Salinas on 17/10/24.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var LogInModel = LogInVM()
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Color.init(red: 0.745, green: 0.839, blue: 0.0)
                .ignoresSafeArea()
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
                    TextField("Nombre", text: $LogInModel.nombre)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(LogInModel.nameError == nil ? Color.clear : Color.red, lineWidth: 1)
                        )
                        .padding(.bottom, 8)
                    
                    // Si existe, mostrar un error en el nombre
                    if let eName = LogInModel.nameError {
                        Text(eName)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                    }

                    Text("Correo")
                        .font(.title3)
                    TextField("correo@example.com", text: $LogInModel.correo)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(LogInModel.mailError == nil ? Color.clear : Color.red, lineWidth: 1)
                        )
                        .padding(.bottom, 8)
                    
                    // Si existe, mostrar un error en el correo
                    if let eMail = LogInModel.mailError {
                        Text(eMail)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                    }
                    
                    Text("Contraseña")
                        .font(.title3)
                    HStack{
                        if LogInModel.isPasswordVisible {
                            TextField("", text: $LogInModel.password)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .autocorrectionDisabled()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(LogInModel.passwordError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                            
                        } else {
                            SecureField("", text: $LogInModel.password)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .autocorrectionDisabled()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(LogInModel.passwordError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                        }
                        
                        Button {
                            LogInModel.isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: LogInModel.isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(AppColors.morado)
                        }
                    }
                    .padding(.bottom, 8)
                    
                    // Si existe, mostrar un error en la contraseña
                    if let ePass = LogInModel.passwordError {
                        Text(ePass)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                    }
                    
                    Text("Edad de los visitantes:")
                        .font(.title3)
                    TextField("Ingresa la edad", value: $LogInModel.edad, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .keyboardType(.numberPad)
                }.padding()
                
                VStack {
                    Toggle(isOn:$LogInModel.isChecked) {
                        Text("Acepto que se recopilen datos de mi visita para mejorar la experiencia.")
                            .font(.headline)
                    }.toggleStyle(CheckboxToggleStyle())
                }.padding(.all, 8)
                
                // Si existe, mostrar un error para el aviso de recopilación de datos
                if let advice = LogInModel.adviceMessage {
                    Text(advice)
                        .foregroundColor(.red) // Color del texto del error
                        .font(.caption) // Tamaño pequeño para el mensaje
                }
                
                VStack {
                    Button {
                        // Enviar los datos de registro a la BD
                        Task {
                            await LogInModel.validarDatos()
                        }
                    } label: {
                        Text("Registrarme")
                            .padding()
                            .font(.title3)
                            .bold()
                            .foregroundStyle(AppColors.morado)
                            .background(AppColors.verde)
                            .cornerRadius(10)
                    }
                    .fullScreenCover(isPresented: $LogInModel.logged) {
                        ContentView()
                    }
                }.padding()
                
                if let errorMessage = LogInModel.newError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    Button {
                        LogInModel.isSignInScreen = true
                    } label : {
                        Text("¿Ya tienes cuenta?")
                            .font(.title2)
                            .foregroundStyle(AppColors.morado)
                    }
                    .fullScreenCover(isPresented: $LogInModel.isSignInScreen) {
                        SignInView()
                    }
                }
            }
            .padding(.bottom, 25)
                    
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.88)
    }
    
    private func validatePostUser() {
        LogInModel.someError = false
        
        if LogInModel.nombre.isEmpty {
            LogInModel.nameError = "Este campo no puede estar vacío."
            LogInModel.someError = true
        } else {
            LogInModel.nameError = nil
        }
        if LogInModel.correo.isEmpty {
            LogInModel.mailError = "Este campo no puede estar vacío."
            LogInModel.someError = true
        } else {
            LogInModel.mailError = nil
        }
        if LogInModel.password.isEmpty{
            LogInModel.passwordError = "Este campo no puede estar vacío."
            LogInModel.someError = true
        } else {
            LogInModel.passwordError = nil
        }
        
        if !LogInModel.isChecked {
            LogInModel.someError = true
            LogInModel.adviceMessage = "Es necesario aceptar el aviso de recopilación de datos."
        } else {
            LogInModel.adviceMessage = nil
        }
        
        // Si no hay nigún error guardar usuario en BD
        if !LogInModel.someError {
            Task {
                await LogInModel.registrarUsuario()
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
