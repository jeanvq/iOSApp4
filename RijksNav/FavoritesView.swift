import SwiftUI

// MARK: - Vista que muestra las obras marcadas como favoritas
struct FavoritesView: View {
    
    @ObservedObject private var favorites = FavoritesManager.shared
    let allItems: [ArtItem]  // Recibe las obras ya cargadas desde ArtListView
    
    var favoriteItems: [ArtItem] {
        allItems.filter { favorites.favoriteIDs.contains($0.id) }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if favoriteItems.isEmpty {
                // MARK: - Estado vacío
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow.opacity(0.5))
                    Text("No favorites yet")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Text("Tap the heart on any artwork to save it here.")
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                // MARK: - Lista de obras favoritas
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(favoriteItems) { item in
                            NavigationLink(destination: ArtDetailView(item: item)) {
                                ArtRowView(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
    }
}
