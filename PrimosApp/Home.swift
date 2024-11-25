import SwiftUI

struct Home: View {
    @StateObject private var actividadesModelo = ActividadesModelo()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(Logos.logo_verde)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
                Text("¿Qué quieres ver en el museo?")
                    .font(.title3)
                    .padding(.bottom, 15)
                
                if !actividadesModelo.zonas.isEmpty {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                        ForEach(actividadesModelo.zonas.prefix(6), id: \.id) { zona in
                            NavigationLink(destination: ActividadesView(actividadesModelo: actividadesModelo, zona: zona)) {
                                VStack {
                                    if let url = URL(string: zona.foto) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 200, height: 125)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 125, height: 75)
                                        }
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 125, height: 75)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                } else {
                    ProgressView("Cargando zonas...")
                        .padding()
                }
            }
            .onAppear {
                Task {
                    await actividadesModelo.getZonas()
                }
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AnunciosView()) {
                        Image(systemName: "bell.fill")
                            .font(.title)
                            .foregroundColor(AppColors.verde)
                            .padding(.trailing, 30)
                            .padding(.top, 30)
                    }
                }
            }
        }
        .padding(.bottom, 50)
    }
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexSanitized)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let red = Double((color & 0xFF0000) >> 16) / 255.0
        let green = Double((color & 0x00FF00) >> 8) / 255.0
        let blue = Double(color & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    Home()
}
