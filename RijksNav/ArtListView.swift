import SwiftUI

// MARK: - Vista principal que muestra la lista de obras del Rijksmuseum
struct ArtListView: View {
    
    // MARK: - ViewModel compartido con toda la app
    @StateObject private var viewModel = RijksViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                // MARK: - Estado de carga
                if viewModel.isLoading {
                    ProgressView("Cargando colección...")
                
                // MARK: - Estado de error
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Reintentar") {
                            Task {
                                await viewModel.fetchArtObjects()
                            }
                        }
                    }
                    .padding()
                
                // MARK: - Lista de obras
                } else {
                    List(viewModel.artItems) { item in
                        NavigationLink(destination: ArtDetailView(item: item)) {
                            ArtRowView(item: item)
                        }
                    }
                    .searchable(text: $viewModel.searchText, prompt: "Buscar obras...")
                    .onSubmit(of: .search) {
                        Task {
                            await viewModel.fetchArtObjects(query: viewModel.searchText)
                        }
                    }
                }
            }
            .navigationTitle("Rijksmuseum")
            .navigationBarTitleDisplayMode(.large)
        }
        // MARK: - Carga inicial al aparecer la vista
        .task {
            await viewModel.fetchArtObjects()
        }
    }
}
