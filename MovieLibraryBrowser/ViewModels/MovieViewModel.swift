//
//  MovieViewModel.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/3/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class MovieViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    @Published var isLoading = false
    @Published var error: MovieError?
    @Published var detailedMovie: DetailMovieModel?
    @Query var localMovies: [MovieModel]
    
    
    @Query(filter: #Predicate<MovieModel> { $0.isFavorite == true })
    private var favoriteMovies: [MovieModel]
    //private var localMovies: [MovieModel]

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }
    func convertTransferObjectToMovieModels(_ transferObjects: [MovieTransferObject]) -> [MovieModel] {
        transferObjects.map { transferObject in
            MovieModel(id: transferObject.id,
                       title: transferObject.title,
                       overview: transferObject.overview,
                       posterPath: transferObject.posterPath,
                       voteAverage: transferObject.voteAverage)
        }
    }
    func convertDetailTransferObjectToDetailModel(_ dto: DetailMovieTransferObject) -> DetailMovieModel {
        let genres = dto.genres.map { Genre(id: $0.id, name: $0.name) }
        let companies = dto.productionCompanies.map {
            ProductionCompany(id: $0.id, name: $0.name)
        }

        return DetailMovieModel(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            backdropPath: dto.backdropPath,
            releaseDate: dto.releaseDate,
            isFavorite: false,
            runtime: dto.runtime,
            genres: genres,
            originCountry: dto.originCountry ?? [],
            productionCompanies: companies
        )
    }

    func loadMovies(for day: String) async {
        
        if localMovies.isEmpty || localMovies[0].isStale {
            do {
                let fetched = try await repository.fetchMoviesFromRemote(day)
                print("Fetched \(fetched.count) movies in vm")
                let convertedMovies = convertTransferObjectToMovieModels(fetched)
                let merged = movies + convertedMovies.filter { convertedMovie in
                    !movies.contains(where: { $0.id == convertedMovie.id })
                }
                self.movies = merged
                try await repository.saveMovies(convertedMovies)
            } catch {
                self.error = MovieError.from(error)
            }
        } else {
            self.movies = localMovies
        }
            
    }
    
    func saveFavoriteMovie(_ movie: MovieModel) {
        repository.saveFavoriteMovie(movie)
    }
    
    func getFavoritedMovies() async {
        isLoading = true
        //favoritedMovies = await repository.getFavoriteMovies()
        isLoading = false
    }
    func getDetailMovie(for id: Int) async {
        isLoading = true
        error = nil
        do {
            let fetched = try await repository.getMovieDetails(for: id)
            isLoading = false
            self.detailedMovie = convertDetailTransferObjectToDetailModel(fetched)
            
        } catch {
            self.error = MovieError.from(error)
            isLoading = false
        }
    }
}
