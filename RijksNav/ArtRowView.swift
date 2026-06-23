import SwiftUI

// MARK: - Vista de una fila individual en la lista de obras
struct ArtRowView: View {
    
    let item: ArtItem
    
    var body: some View {
        HStack(spacing: 12) {
            
            // MARK: - Imagen usando base64 lqip del thumbnail
            if let lqip = item.thumbnail?.lqip,
               let data = Data(base64Encoded: lqip.components(separatedBy: ",").last ?? ""),
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                // MARK: - Placeholder si no hay imagen
                Image(systemName: "photo.artframe")
                    .font(.title2)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // MARK: - Información textual de la obra
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title ?? "Sin título")
                    .font(.headline)
                    .lineLimit(2)
                
                if let artist = item.artistDisplay {
                    Text(artist)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                if let date = item.dateDisplay {
                    Text(date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
