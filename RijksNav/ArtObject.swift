import Foundation

// MARK: - Respuesta de búsqueda del Met — devuelve lista de IDs
struct SearchResponse: Codable {
    let total: Int
    let objectIDs: [Int]?
}

// MARK: - Representa una obra de arte individual del Met Museum
struct ArtItem: Codable, Identifiable {
    let id: Int                         // ID único (objectID)
    let title: String?                  // Título de la obra
    let artistDisplayName: String?      // Nombre del artista
    let objectDate: String?             // Fecha de creación
    let country: String?                // País de origen
    let medium: String?                 // Material o técnica
    let dimensions: String?             // Dimensiones
    let primaryImageSmall: String?      // URL imagen pequeña
    let primaryImage: String?           // URL imagen completa
    let department: String?             // Departamento del museo
    let objectURL: String?              // Link a la página del Met
    
    // MARK: - URL de imagen para mostrar en la app
    var imageURL: URL? {
        guard let urlString = primaryImageSmall, !urlString.isEmpty else { return nil }
        return URL(string: urlString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "objectID"
        case title
        case artistDisplayName
        case objectDate
        case country
        case medium
        case dimensions
        case primaryImageSmall
        case primaryImage
        case department
        case objectURL
    }
}
