//
//  MovieView.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/3/25.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    @State var movie: MovieModel
    @State var movieViewModel: MovieViewModel
    var body: some View {
        MovieContentView(movie: $movie, movieViewModel: movieViewModel)
    }
    
}

struct MovieContentView: View {
    @Binding var movie: MovieModel
    @State var movieViewModel: MovieViewModel
    var body: some View {
        VStack{
            ZStack(alignment: .topTrailing){
                NavigationLink(destination: DetailView(movieModel: movie, viewModel: movieViewModel)) {
                    KFImage(URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath ?? "")"))
                        .placeholder {
                            ProgressView()
                        }
                        .retry(maxCount: 3, interval: .seconds(5))
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        movie.isFavorite.toggle()
                        movieViewModel.saveFavoriteMovie(movie)
                    }) {
                        Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(movie.isFavorite ? .red : .gray)
                            .padding()
                    }
                }
                        
                
            Text(movie.title)
            HStack{
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text(String(movie.voteAverage))
            }
            
        }
        
    }
}
