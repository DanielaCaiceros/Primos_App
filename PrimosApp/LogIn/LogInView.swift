//
//  LogInView.swift
//  PapaloteLogIn
//
//  Created by Joirid Juarez Salinas on 17/10/24.
//

import SwiftUI

struct LogInView: View {
    @State var usuario = ""
    @State var correo = ""
    @State var password = ""
    @State var edad = 0
    @State private var isPasswordVisible: Bool = false
    @State private var isChecked: Bool = false
    @State private var isSignInScreen: Bool = false
    
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
                    TextField("Nombre", text: $correo)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .padding(.bottom, 8)
                    
                    Text("Correo")
                        .font(.title3)
                    TextField("correo@example.com", text: $usuario)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .padding(.bottom, 8)
                    
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
                    .padding(.bottom, 8)
                    
                    Text("Edad de los visitantes:")
                        .font(.title3)
                    TextField("Ingresa la edad", value: $edad, formatter: NumberFormatter())
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
                
                VStack {
                    Button {
                        // Enviar los datos de registro a la BD
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
    
    func salt() {
        
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
