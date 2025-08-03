//
//  FavoritesView.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/2/25.
//

import SwiftUI
import SwiftData


struct FavoritesView: View {
    @StateObject var viewModel: MovieViewModel
    @Query(filter: #Predicate<MovieModel> { $0.isFavorite == true })
    private var movies: [MovieModel]
    var body: some View {
        Text("Favorites")
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach (movies) { movie in
                    FavoritedMovieView(movie:movie)
                }
            }
        }
        Spacer()
    }
}
