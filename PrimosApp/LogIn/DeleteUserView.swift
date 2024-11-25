//
//  DeleteUserView.swift
//  PrimosApp
//
//  Created by Joirid Juarez Salinas on 22/11/24.
//

import SwiftUI

struct DeleteUserView: View {
    @StateObject private var DeleteModel = DeleteVM()
    
    var body: some View {
        VStack{
            Text("Correo")
                .font(.title3)
            TextField("correo@example.com", text: $DeleteModel.correo)
                .textFieldStyle(.roundedBorder)
                .font(.title3)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .padding(.bottom, 8)
            
            
            Text("Contraseña")
                .font(.title3)
            TextField("", text: $DeleteModel.password)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .autocorrectionDisabled()
                                        
            Button {
                // Task
                DeleteModel.deleteUser()
            } label: {
                Text("Eliminar")
                    .padding(10)
                    .background(.black)
                    .foregroundStyle(.white)
            }
        }
        .padding(20)
    }
}

#Preview {
    DeleteUserView()
}
