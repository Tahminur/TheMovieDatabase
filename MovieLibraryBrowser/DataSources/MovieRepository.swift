//
//  MovieRepository.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/3/25.
//

import Foundation

protocol MovieRepository {
    
    func getFavoriteMovies() async -> [MovieModel]
    
    func fetchMoviesFromRemote(_ timePeriod: String) async throws -> [MovieTransferObject]
    
    func getMovieDetails(for id: Int) async throws -> DetailMovieTransferObject
    
    func saveMovies(_ movies: [MovieModel]) async throws
    
    func saveFavoriteMovie(_ movie: MovieModel)
    
    func clearCache() async throws
    
    func checkIfStale() async -> (movie: [MovieModel]?, isFresh: Bool)
}


class MovieRepositoryImpl: MovieRepository {
    
    private let local: MovieLocalDataSource
    private let remote: MovieRemoteDataSource
    
    init(local: MovieLocalDataSource, remote: MovieRemoteDataSource) {
        self.local = local
        self.remote = remote
    }
    
    func getFavoriteMovies() async -> [MovieModel] {
        await local.getFavoriteMovies()
    }
    
    func saveMovies(_ movies: [MovieModel]) async throws {
        do{
            try await local.saveMovies(movies)
        } catch {
            throw error
        }
    }
    
    func saveFavoriteMovie(_ movie: MovieModel) {
        local.saveFavoriteMovie(movie)
    }
    
    func getMovieDetails(for id: Int) async throws -> DetailMovieTransferObject {
        do {
            let data = try await remote.fetchMovieDetails(for: id)
            //handle conversion to movie here and return models
            print("trying to decode to detailed movie object")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let response = try decoder.decode(DetailMovieTransferObject.self, from: data)
            return response
        } catch {
            throw error
        }
    }
    
    func fetchMoviesFromRemote(_ timePeriod: String) async throws -> [MovieTransferObject] {
        do {
            let data = try await remote.fetchMovies(for: timePeriod)
            //handle conversion to movie here and return models
            print("trying to decode to movie transfer objects")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let response = try decoder.decode(MovieResponse.self, from: data)
            let movies = response.results
            return movies
        } catch {
            throw error
        }
    }
    
    func checkIfStale() async -> (movie: [MovieModel]?, isFresh: Bool){
        await local.getMoviesIfFresh()
    }
    
    func clearCache() async throws {
        print("clearcache")
    }
    
    
}
