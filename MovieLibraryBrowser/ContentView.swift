//
//  ContentView.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/2/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        let remote = TMDBMovieRemoteDataSource()
        let local = SwiftDataLocalDataSource(context: modelContext)
        let viewModel = MovieViewModel(repository: MovieRepositoryImpl(local: local, remote: remote))
        TabView {
            NavigationStack {
                HomeView(viewModel: viewModel)
                .navigationTitle("TMDB Movie")
            }
            .tabItem {
                Label("Home", systemImage: "house")
                }
            NavigationStack {
                FavoritesView(viewModel: viewModel)
                    .navigationTitle("TMDB Movie")
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            NavigationStack {
                SettingsView()
                    .navigationTitle("TMDB Movie")
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
