import SwiftUI

// MARK: - Vista de detalle de una obra de arte individual
struct ArtDetailView: View {
    
    let item: ArtItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Imagen principal usando base64 lqip
                if let lqip = item.thumbnail?.lqip,
                   let data = Data(base64Encoded: lqip.components(separatedBy: ",").last ?? ""),
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    // MARK: - Placeholder si no hay imagen
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // MARK: - Información detallada de la obra
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Título
                    Text(item.title ?? "Sin título")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    // Artista
                    if let artist = item.artistDisplay {
                        DetailRowView(label: "Artista", value: artist)
                    }
                    
                    // Fecha
                    if let date = item.dateDisplay {
                        DetailRowView(label: "Fecha", value: date)
                    }
                    
                    // Lugar de origen
                    if let place = item.placeOfOrigin {
                        DetailRowView(label: "Origen", value: place)
                    }
                    
                    // Material o técnica
                    if let medium = item.mediumDisplay {
                        DetailRowView(label: "Técnica", value: medium)
                    }
                    
                    // Dimensiones
                    if let dimensions = item.dimensions {
                        DetailRowView(label: "Dimensiones", value: dimensions)
                    }
                    
                    // MARK: - Link al museo
                    Link("Ver en Art Institute of Chicago →",
                         destination: URL(string: "https://www.artic.edu/artworks/\(item.id)")!)
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Componente reutilizable para mostrar un par label/valor
struct DetailRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(width: 110, alignment: .leading)
            Text(value)
                .foregroundColor(.primary)
            Spacer()
        }
    }
}
