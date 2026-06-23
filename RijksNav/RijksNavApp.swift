import SwiftUI

// MARK: - Punto de entrada principal de la app RijksNav
@main
struct RijksNavApp: App {
    var body: some Scene {
        WindowGroup {
            // ArtListView es la vista raíz de la aplicación
            ArtListView()
        }
    }
}
