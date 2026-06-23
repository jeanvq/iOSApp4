import Foundation

// MARK: - Respuesta principal de la API del Art Institute of Chicago
struct SearchResponse: Codable {
    let data: [ArtItem]
    let pagination: Pagination
}

// MARK: - Información de paginación
struct Pagination: Codable {
    let total: Int
    let currentPage: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case total
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

// MARK: - Thumbnail con imagen en base64 de baja resolución
struct Thumbnail: Codable {
    let lqip: String?       // Imagen base64 de preview
    let altText: String?
    
    enum CodingKeys: String, CodingKey {
        case lqip
        case altText = "alt_text"
    }
}

// MARK: - Representa una obra de arte individual del museo
struct ArtItem: Codable, Identifiable {
    let id: Int
    let title: String?
    let artistDisplay: String?
    let dateDisplay: String?
    let placeOfOrigin: String?
    let mediumDisplay: String?
    let dimensions: String?
    let imageId: String?
    let thumbnail: Thumbnail?       // Contiene imagen base64 de preview
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artistDisplay = "artist_display"
        case dateDisplay = "date_display"
        case placeOfOrigin = "place_of_origin"
        case mediumDisplay = "medium_display"
        case dimensions
        case imageId = "image_id"
        case thumbnail
    }
}
