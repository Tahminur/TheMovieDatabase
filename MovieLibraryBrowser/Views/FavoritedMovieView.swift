//
//  FavoritedMovieView.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/4/25.
//

import SwiftUI
import Kingfisher

struct FavoritedMovieView: View {
    var movie: MovieModel
    var body: some View {
        HStack {
            KFImage(URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath ?? "")"))
                .placeholder {
                    ProgressView()
                }
                .retry(maxCount: 3, interval: .seconds(5))
                .fade(duration: 0.25)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Text(movie.title)
                .font(.headline)
        }
    }
}
