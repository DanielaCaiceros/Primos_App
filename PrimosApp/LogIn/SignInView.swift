//
//  SignInView.swift
//  PapaloteLogIn
//
//  Created by Joirid Juarez Salinas on 04/11/24.
//

import SwiftUI

struct SignInView: View {
    @State var usuario = ""
    @State var correo = ""
    @State var password = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isLogInScreen: Bool  = false
    
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
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .padding(.bottom, 15)
                VStack (alignment: .leading) {
                    Text("Nombre")
                        .font(.title3)
                    TextField("Nombre", text: $correo)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .padding(.bottom, 20)
                    
                    Text("Contraseña")
                        .font(.title3)
                    HStack{
                        if isPasswordVisible {
                            TextField("", text: $password)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .autocorrectionDisabled()
                            
                        } else {
                            SecureField("12345", text: $password)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .autocorrectionDisabled()
                        }
                        
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(AppColors.morado)
                        }
                    }
                }
                
                Button {
                    // Enviar los datos de registro a la BD
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
                
                HStack {
                    Button {
                        isLogInScreen = true
                    } label : {
                        Text("¿Todavía no tienes cuenta?")
                            .font(.title3)
                            .foregroundStyle(AppColors.morado)
                    }
                    .fullScreenCover(isPresented: $isLogInScreen) {
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
