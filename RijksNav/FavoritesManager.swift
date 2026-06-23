import Foundation
import Combine

// MARK: - Maneja el almacenamiento local de obras favoritas usando UserDefaults
@MainActor
class FavoritesManager: ObservableObject {
    
    static let shared = FavoritesManager()
    
    // MARK: - Lista de IDs favoritos persistida localmente
    @Published var favoriteIDs: Set<Int> = []
    
    private let key = "favoriteArtIDs"
    
    init() {
        load()
    }
    
    // MARK: - Verifica si una obra es favorita
    func isFavorite(_ item: ArtItem) -> Bool {
        favoriteIDs.contains(item.id)
    }
    
    // MARK: - Agrega o quita una obra de favoritos
    func toggle(_ item: ArtItem) {
        if isFavorite(item) {
            favoriteIDs.remove(item.id)
        } else {
            favoriteIDs.insert(item.id)
        }
        save()
    }
    
    // MARK: - Guarda los favoritos en UserDefaults
    private func save() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: key)
    }
    
    // MARK: - Carga los favoritos desde UserDefaults
    private func load() {
        let saved = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        favoriteIDs = Set(saved)
    }
}
