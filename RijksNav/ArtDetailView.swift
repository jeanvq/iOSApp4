import SwiftUI

// MARK: - Vista de detalle de una obra de arte con estilo oscuro y dorado
struct ArtDetailView: View {
    
    let item: ArtItem
    
    @ObservedObject private var favorites = FavoritesManager.shared
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Imagen principal
                    AsyncImage(url: item.imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1.5)
                                )
                                .shadow(color: .yellow.opacity(0.15), radius: 12)
                        case .failure:
                            Image(systemName: "photo.artframe")
                                .font(.system(size: 60))
                                .foregroundColor(.yellow.opacity(0.5))
                                .frame(maxWidth: .infinity, minHeight: 200)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        case .empty:
                            ProgressView()
                                .tint(.yellow)
                                .frame(maxWidth: .infinity, minHeight: 200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    // MARK: - Título y artista destacados
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.title ?? "No Title")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        if let artist = item.artistDisplayName, !artist.isEmpty {
                            Text(artist)
                                .font(.subheadline)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    // MARK: - Separador dorado
                    Rectangle()
                        .fill(Color.yellow.opacity(0.4))
                        .frame(height: 1)
                    
                    // MARK: - Detalles de la obra
                    VStack(alignment: .leading, spacing: 14) {
                        
                        if let date = item.objectDate, !date.isEmpty {
                            DetailRowView(label: "Date", value: date)
                        }
                        if let country = item.country, !country.isEmpty {
                            DetailRowView(label: "Origin", value: country)
                        }
                        if let department = item.department, !department.isEmpty {
                            DetailRowView(label: "Departament", value: department)
                        }
                        if let medium = item.medium, !medium.isEmpty {
                            DetailRowView(label: "Medium", value: medium)
                        }
                        if let dimensions = item.dimensions, !dimensions.isEmpty {
                            DetailRowView(label: "Dimensions", value: dimensions)
                        }
                    }
                    
                    // MARK: - Link al Met Museum
                    if let urlString = item.objectURL, let url = URL(string: urlString) {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "arrow.up.right.square")
                                Text("Watch at The Met Museum")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    favorites.toggle(item)
                } label: {
                    Image(systemName: favorites.isFavorite(item) ? "heart.fill" : "heart")
                        .foregroundColor(.yellow)
                        .font(.title3)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
    }
}

// MARK: - Componente reutilizable para mostrar un par label/valor
struct DetailRowView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.yellow.opacity(0.7))
                .frame(width: 100, alignment: .leading)
                .textCase(.uppercase)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}
