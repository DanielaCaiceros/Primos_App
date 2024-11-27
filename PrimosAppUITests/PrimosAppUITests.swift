//
//  PrimosAppUITests.swift
//  PrimosAppUITests
//
//  Created by Daniela Caiceros on 12/10/24.
//

import XCTest

final class PrimosAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Configuración inicial antes de cada prueba
        continueAfterFailure = false

        // Lanzar la aplicación antes de cada prueba
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Limpiar el estado después de cada prueba
    }

    @MainActor
    func testActividadListVisible() throws {
        let app = XCUIApplication()
        
        // Verifica que el contenedor principal esté visible
        let mainVStack = app.scrollViews.firstMatch
        XCTAssertTrue(mainVStack.exists, "El contenedor principal debería estar visible.")
    }
    
    @MainActor
    func testAgregarActividadARuta() throws {
        let app = XCUIApplication()
        
        // Encuentra el primer botón "Añadir a mi ruta"
        let firstAddButton = app.buttons["Añadir a mi ruta"].firstMatch
        
        // Verifica que el botón existe
        XCTAssertTrue(firstAddButton.exists, "El botón 'Añadir a mi ruta' debería estar visible.")
        
        // Realiza un tap en el botón
        firstAddButton.tap()
        
        // Puedes agregar validaciones adicionales si se espera algún cambio visual o mensaje de confirmación
    }
    
    @MainActor
    func testMostrarImagenActividad() throws {
        let app = XCUIApplication()
        
        // Verifica que la imagen principal de la zona esté presente
        let zonaImage = app.images.firstMatch
        XCTAssertTrue(zonaImage.exists, "La imagen de la zona debería estar visible.")
        
        // Verifica que al menos una imagen de actividad esté presente en la lista
        let actividadImage = app.scrollViews.images.firstMatch
        XCTAssertTrue(actividadImage.exists, "La imagen de la actividad debería estar visible.")
    }
    
    @MainActor
    func testScrollEnActividades() throws {
        let app = XCUIApplication()
        
        // Localiza la lista de actividades
        let actividadList = app.scrollViews.firstMatch
        
        // Asegúrate de que la lista existe antes de intentar interactuar
        XCTAssertTrue(actividadList.exists, "La lista de actividades debería estar visible.")
        
        // Realiza un swipe para desplazarse hacia abajo en la lista
        actividadList.swipeUp()
        
        // Realiza un swipe para desplazarse hacia arriba en la lista
        actividadList.swipeDown()
    }
    
    @MainActor
    func testBotonAgregarPresenteEnCadaActividad() throws {
        let app = XCUIApplication()
        
        // Verifica que haya múltiples botones "Añadir a mi ruta"
        let addButtons = app.buttons.matching(identifier: "Añadir a mi ruta")
        XCTAssertTrue(addButtons.count > 0, "Debería haber al menos un botón 'Añadir a mi ruta' visible.")
        
        // Comprueba que todos los botones están visibles
        for index in 0..<addButtons.count {
            let button = addButtons.element(boundBy: index)
            XCTAssertTrue(button.exists, "El botón 'Añadir a mi ruta' en la posición \(index) debería estar visible.")
        }
    }
}
