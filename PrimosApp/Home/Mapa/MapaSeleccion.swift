import SwiftUI

struct MapaSeleccion: View {
    @State private var selectedFloor: String = "PB_mapa"
    @State private var showMapDetail = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack {
                    Image(Logos.logo_verde)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                    
                    Text("Mapa del museo")
                        .font(.title)
                        .padding(.top, 10)
                }
                
                HStack {
                    Button(action: {
                        selectedFloor = "PB_mapa"
                    }) {
                        Text("Piso 1")
                            .foregroundColor(selectedFloor == "PB_mapa" ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedFloor == "PB_mapa" ? Color.gray : Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        selectedFloor = "PA_mapa"
                    }) {
                        Text("Piso 2")
                            .foregroundColor(selectedFloor == "PA_mapa" ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedFloor == "PA_mapa" ? Color.gray : Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    showMapDetail = true
                }) {
                    Image(selectedFloor)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 400)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $showMapDetail) {
                if selectedFloor == "PB_mapa" {
                    Mapa() // Navega al mapa de detalle de Piso 1
                } else {
                    Mapa1() // Navega al mapa de detalle de Piso 2
                }
            }
        }
    }
}

#Preview {
    MapaSeleccion()
}
