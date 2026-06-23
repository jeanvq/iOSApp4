import Foundation
import Combine

// MARK: - ViewModel que maneja la lógica y las llamadas a la API del Art Institute of Chicago
class RijksViewModel: ObservableObject {
    
    // MARK: - Propiedades publicadas (actualizan la UI automáticamente)
    @Published var artItems: [ArtItem] = []     // Lista de obras de arte
    @Published var isLoading: Bool = false       // Indicador de carga
    @Published var errorMessage: String? = nil   // Mensaje de error si falla la API
    @Published var searchText: String = ""       // Texto de búsqueda del usuario
    
    // MARK: - URL base de la API del Art Institute of Chicago (sin API key)
    private let baseURL = "https://api.artic.edu/api/v1/artworks"
    
    // MARK: - Carga obras de arte desde la API
    func fetchArtObjects(query: String = "") async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Construimos la URL — con búsqueda o listado general
        var urlString: String
        if query.isEmpty {
            urlString = "\(baseURL)?limit=20&fields=id,title,artist_display,date_display,place_of_origin,medium_display,dimensions,image_id,thumbnail"
        } else {
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            urlString = "https://api.artic.edu/api/v1/artworks/search?q=\(encoded)&limit=20&fields=id,title,artist_display,date_display,place_of_origin,medium_display,dimensions,image_id,thumbnail"
        }
        
        guard let url = URL(string: urlString) else {
            await MainActor.run {
                errorMessage = "URL inválida"
                isLoading = false
            }
            return
        }
        
        do {
            // Hacemos la llamada a la API
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decodificamos la respuesta JSON
            let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
            
            await MainActor.run {
                self.artItems = decoded.data
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
