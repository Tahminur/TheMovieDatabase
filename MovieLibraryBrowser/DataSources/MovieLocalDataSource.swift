//
//  MovieLocalDataSource.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/3/25.
//

import SwiftData
import SwiftUI
import Foundation

protocol MovieLocalDataSource {
    func saveMovies(_ movies: [MovieModel]) async throws
    func saveFavoriteMovie(_ movie: MovieModel)
    func getFavoriteMovies() async -> [MovieModel]
    func getMoviesIfFresh() async -> (movie: [MovieModel]?, isFresh: Bool)
}

class SwiftDataLocalDataSource: MovieLocalDataSource {
    
    private let modelContext: ModelContext
    @Query var movies: [MovieModel]
    init(context: ModelContext) {
        self.modelContext = context
    }
    func getMoviesIfFresh() async -> (movie: [MovieModel]?, isFresh: Bool) {
        do {
            let cached = try modelContext.fetch(FetchDescriptor<MovieModel>(
            ))
            guard cached.count > 0 else {
                return (nil, false)
            }
            return (cached, cached.first!.isStale)
        } catch {
            print("Error fetching movie from local cache:", error)
            return (nil, false)
        }
    }
    func getFavoriteMovies() async -> [MovieModel] {
        return movies
    }
    
    func saveMovies(_ movies: [MovieModel]) async throws {
        do {
            for movie in movies {
                if movie.isFavorite {
                    continue
                } else {
                    modelContext.insert(movie)
                }
            }
            try modelContext.save()
        } catch {
            print("Failed to save movies:", error)
            throw error
        }
    }
    
    func saveFavoriteMovie(_ movie: MovieModel) {
        modelContext.insert(movie)
        try? modelContext.save()
    }

}
