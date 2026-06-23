import SwiftUI

// MARK: - Vista de una fila individual en la lista de obras con estilo oscuro y dorado
struct ArtRowView: View {
    
    let item: ArtItem
    
    var body: some View {
        HStack(spacing: 14) {
            
            // MARK: - Imagen de la obra
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.yellow.opacity(0.4), lineWidth: 1)
                        )
                case .failure:
                    Image(systemName: "photo.artframe")
                        .font(.title2)
                        .frame(width: 75, height: 75)
                        .foregroundColor(.yellow.opacity(0.5))
                        .background(Color.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .empty:
                    ProgressView()
                        .tint(.yellow)
                        .frame(width: 75, height: 75)
                @unknown default:
                    EmptyView()
                }
            }
            
            // MARK: - Información textual
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title ?? "Sin título")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let artist = item.artistDisplayName, !artist.isEmpty {
                    Text(artist)
                        .font(.subheadline)
                        .foregroundColor(.yellow.opacity(0.85))
                        .lineLimit(1)
                }
                
                if let date = item.objectDate, !date.isEmpty {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.yellow.opacity(0.15), lineWidth: 1)
        )
    }
}
