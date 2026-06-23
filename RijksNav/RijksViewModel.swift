import Foundation
import Combine

// MARK: - ViewModel que maneja la lógica y las llamadas a la API del Met Museum
class RijksViewModel: ObservableObject {
    
    // MARK: - Propiedades publicadas (actualizan la UI automáticamente)
    @Published var artItems: [ArtItem] = []     // Lista de obras de arte
    @Published var isLoading: Bool = false       // Indicador de carga
    @Published var errorMessage: String? = nil   // Mensaje de error
    @Published var searchText: String = ""       // Texto de búsqueda
    
    // MARK: - URL base de la API pública del Met Museum (sin API key)
    private let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1"
    
    // MARK: - Busca obras y carga sus detalles
    func fetchArtObjects(query: String = "impressionism") async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
            artItems = []
        }
        
        // Paso 1: Buscar IDs de obras que tengan imagen pública
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let searchURL = "\(baseURL)/search?hasImages=true&q=\(encoded)"
        
        guard let url = URL(string: searchURL) else {
            await MainActor.run { isLoading = false }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let searchResult = try JSONDecoder().decode(SearchResponse.self, from: data)
            
            // Tomamos solo los primeros 20 IDs para no sobrecargar
            let ids = Array((searchResult.objectIDs ?? []).prefix(20))
            
            // Paso 2: Cargar detalles de cada obra en paralelo
            var items: [ArtItem] = []
            try await withThrowingTaskGroup(of: ArtItem?.self) { group in
                for id in ids {
                    group.addTask {
                        guard let detailURL = URL(string: "\(self.baseURL)/objects/\(id)") else { return nil }
                        let (detailData, _) = try await URLSession.shared.data(from: detailURL)
                        return try? JSONDecoder().decode(ArtItem.self, from: detailData)
                    }
                }
                for try await item in group {
                    if let item = item {
                        items.append(item)
                    }
                }
            }
            
            // Filtramos obras sin imagen y ordenamos por ID
            let filtered = items.filter { $0.primaryImageSmall?.isEmpty == false }
                                .sorted { $0.id < $1.id }
            
            await MainActor.run {
                self.artItems = filtered
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Error al cargar datos: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}
