//
//  ToastView.swift
//  PrimosApp
//
//  Created by Alumno on 25/11/24.
//

import SwiftUI

struct ToastView: View {
    @Binding var isShowing: Bool
    let message: String

    var body: some View {
        VStack {
            Text(message)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
        .transition(.opacity)
        .animation(.easeInOut)
    }
}
