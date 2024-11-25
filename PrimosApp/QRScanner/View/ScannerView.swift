//
//  ScannerView.swift
//  QRScanner
//
//  Created by Joirid Juarez Salinas on 28/10/24.
//

import SwiftUI
import AVKit

struct QRScannerView: View {
    // QR Scanner Properties
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    // QR Scanner AV Output
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    // Error Properties
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    // Camera Output Delegate
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    // Scanned Code
    @State private var scannedCode:  String = ""
    @State private var showDetailedInfo: Bool = false
    // Propiedades para almacenar los datos del URL
    @State private var destinationScreen: String = ""
    @State private var actividadID: String = ""
    
    
    var body: some View {
        VStack {
            Spacer()
            // Icono y logo
            Image("logo_papalote") // Agrega la imagen del logo
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            Text("Escanea el código QR")
                .font(.title)
                .foregroundColor(.gray)
            
            Spacer(minLength: 0)
            
            // Scanner
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                    // Making it a little smaller
                        .scaleEffect(0.97)
                    
                    // Esquinas del codeScanner
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double(index) * 90
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                }
                // Square Shape
                .frame(width: size.width, height: size.width)
                // Animación
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2.5)
                        .shadow(color:.black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 12 : -12)
                        .offset(y: isScanning ? size.width : 0)
                })
                // Posicionamiento en pantalla
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            
            Spacer(minLength: 15)
            
            Button {
                if !session.isRunning && cameraPermission == .approved {
                    reactivateCamera()
                }
            } label : {
                HStack {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Volver a escanear")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer(minLength: 45)
        }
        .padding(15)
        // Checking Camera Permission, when the view is visible
        .onAppear(perform: checkCameraPermission)
        .alert(errorMessage, isPresented: $showError) {
             // Showing Settings Button, if permission is Denied
            if cameraPermission == .denied {
                Button("Configuración") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingsString) {
                        // Openning App Setting, using openURL SwiftUI API
                        openURL(settingsURL)
                    }
                }
                
                // Along with Cancel Button
                Button ("Cancelar", role: .cancel) {
                }
            }
        }
        .onChange(of: qrDelegate.scannedCode) {
            if let code = qrDelegate.scannedCode {
                scannedCode = code
                // When the first Code Scan is available, immediatly stop the camera
                session.stopRunning()
                // Stoping Scanner Animation
                deactivateScannerAnimation()
                // Clearing Data onDelegate
                qrDelegate.scannedCode = nil
                // Handle de scanned code
                handleScannedCode()
            }
        }
        .sheet(isPresented: $showDetailedInfo, onDismiss: {
            reactivateCamera()
        }) {
            DetailedInfoView(id: actividadID)
        }
        .onDisappear() {
            session.stopRunning()
        }
    }
    
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
            activateScannerAnimation()
        }
    }
    // Activating Scanner Animation Method
    func activateScannerAnimation() {
        // Adding delay for each reversal
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    // Deactivating Scanner Animation Method
    func deactivateScannerAnimation() {
        // Adding delay for each reversal
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    // Checking Camera Permission
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    // New setup
                    setupCamera()
                } else {
                    // Already existing one
                    session.startRunning()
                }
            case .notDetermined:
                // Requesting Camera Access
                if await AVCaptureDevice.requestAccess(for: .video) {
                    // Permission Granted
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    // Permission Denied
                    cameraPermission = .denied
                    // Presenting Error Message
                    presentError("Proporcione acceso a la cámara para escanear código QR")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Proporcione acceso a la cámara para escanear código QR")
            default:
                break
            }
        }
    }
    
    // Setting Up Camera
    func setupCamera() {
        do  {
            // Finding Back Camera
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN DEVICE ERROR")
                return
            }
            
            // Camera Input
            let input = try AVCaptureDeviceInput(device: device)
            // For Extra Safety
            // Checking whether input & output can be added to the session
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN INPUT/OUTPUT ERROR")
                return
            }
            
            // Adding input & output to Camera Session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            // Setting Output config to read QR Codes
            qrOutput.metadataObjectTypes = [.qr]
            // Adding delegate to Retrieve the Fetched QR Code From Camera
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            // Session must be started on Background thread
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    // Presenting Error
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }

    func handleScannedCode() {
        guard let url = URL(string: scannedCode) else {
            presentError("Código QR inválido")
            return
        }
        
        if url.scheme == "PrimosApp", url.host == "DetailedInfoView" {
            destinationScreen = url.host ?? "None"
            if let components = URLComponents(string: scannedCode),
               let actividadID = components.queryItems?.first(where: { $0.name == "actividadID" })?.value {
                self.actividadID = actividadID
                print(actividadID)
                showDetailedInfo = true // Activar la navegación a pantalla de detalle
            }
        }
    }
     
}

#Preview {
    QRScannerView()
}
