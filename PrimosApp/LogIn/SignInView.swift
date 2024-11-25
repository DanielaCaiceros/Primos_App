//
//  SignInView.swift
//  PapaloteLogIn
//
//  Created by Joirid Juarez Salinas on 04/11/24.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var SignInModel = SignInVM()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.init(red: 0.745, green: 0.839, blue: 0.0)
                .ignoresSafeArea()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.08)
        
        ZStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .padding(.bottom, 15)
                VStack (alignment: .leading) {
                    Text("Correo")
                        .font(.title3)
                    TextField("correo@example.com", text: $SignInModel.correo)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(SignInModel.mailError == nil ? Color.clear : Color.red, lineWidth: 1)
                        )
                        .padding(.bottom, 8)
                    
                    // Si existe, mostrar un error en el nombre
                    if let error = SignInModel.mailError {
                        Text(error)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                            .padding(.bottom, 8)
                    }
                    
                    Text("Contraseña")
                        .font(.title3)
                    HStack{
                        if SignInModel.isPasswordVisible {
                            TextField("", text: $SignInModel.password)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(SignInModel.passwordError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                            
                        } else {
                            SecureField("", text: $SignInModel.password)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(SignInModel.passwordError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                        }
                        
                        Button {
                            SignInModel.isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: SignInModel.isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(AppColors.morado)
                        }
                    }
                    
                    // Si existe, mostrar un error en el nombre
                    if let error = SignInModel.passwordError {
                        Text(error)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                    }
                    
                    // Si existe, mostrar un error en el nombre
                    if let error = SignInModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red) // Color del texto del error
                            .font(.caption) // Tamaño pequeño para el mensaje
                    }
                }
                
                
                Button {
                    Task {
                        await SignInModel.validarDatosSignIn()
                    }
                    
                } label: {
                    Text("Ingresar")
                        .padding()
                        .font(.title3)
                        .bold()
                        .foregroundStyle(AppColors.morado)
                        .background(AppColors.verde)
                        .cornerRadius(10)
                }
                .padding(.all, 20)
                .fullScreenCover(isPresented: $SignInModel.logged) {
                    ContentView()
                }
                
                HStack {
                    Button {
                        SignInModel.isLogInScreen = true
                    } label : {
                        Text("¿Todavía no tienes cuenta?")
                            .font(.title3)
                            .foregroundStyle(AppColors.morado)
                    }
                    .fullScreenCover(isPresented: $SignInModel.isLogInScreen) {
                        LogInView()
                    }
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.88)
    }
}

#Preview {
    SignInView()
}
