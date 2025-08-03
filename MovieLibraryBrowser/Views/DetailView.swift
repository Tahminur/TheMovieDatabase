//
//  DetailView.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/2/25.
//
import SwiftUI
import Kingfisher

struct DetailView: View {
    @State var movieModel: MovieModel
    @StateObject var viewModel: MovieViewModel
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let movie = viewModel.detailedMovie {
                VStack(alignment: .leading) {
                    ZStack(alignment: .topTrailing){
                        KFImage(URL(string: "https://image.tmdb.org/t/p/w500/\(movie.backdropPath ?? "")")!)
                            .retry(maxCount: 3, interval: .seconds(5))
                            .fade(duration: 0.25)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        Button(action: {
                            movieModel.isFavorite.toggle()
                            movie.isFavorite.toggle()
                            viewModel.saveFavoriteMovie(movieModel)
                        }) {
                            Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(movie.isFavorite ? .red : .gray)
                                .padding()
                        }
                    }
                    Text(movie.title).font(.title)
                    Text("Overview").font(.caption).padding(.bottom, 12)
                    Text(movie.overview).font(.caption).padding(.bottom, 12)
                    Text(movie.releaseDate ?? "").font(.caption).padding(.bottom, 12)
                    HStack{
                        Text(movie.originCountry.first ?? "").font(.caption)
                        ForEach(movie.genres) { genre in
                            Text(genre.name).font(.caption)
                        }
                    }.padding(.bottom, 12)
                    Text("\(movie.runtime)m").font(.caption)
                        .padding(.bottom, 12)
                    VStack(alignment: .leading){
                        ForEach(movie.productionCompanies) { company in
                            Text(company.name).font(.caption)
                        }
                    }
                }.padding(.bottom, 12)
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
            }
        }
        .task {
            await viewModel.getDetailMovie(for: movieModel.id)
        } .padding()
        Spacer()
    }
}
