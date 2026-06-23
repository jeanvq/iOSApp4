import SwiftUI

// MARK: - Vista principal que muestra la lista de obras del Met Museum
struct ArtListView: View {
    
    @StateObject private var viewModel = RijksViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Fondo oscuro
                Color.black.ignoresSafeArea()
                
                Group {
                    if viewModel.isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .tint(.yellow)
                                .scaleEffect(1.5)
                            Text("Loading Content...")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                            Text(error)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            Button("Reintentar") {
                                Task { await viewModel.fetchArtObjects(query: "impressionism") }
                            }
                            .foregroundColor(.yellow)
                        }
                        .padding()
                        
                    } else {
                        // MARK: - Lista de obras
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.artItems) { item in
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
            }
            .navigationTitle("The Met Museum")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(allItems: viewModel.artItems)) {                        Image(systemName: "heart.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search Paintings")
            .onSubmit(of: .search) {
                Task { await viewModel.fetchArtObjects(query: viewModel.searchText) }
            }
        }
        .task {
            await viewModel.fetchArtObjects(query: "impressionism")
        }
    }
}
