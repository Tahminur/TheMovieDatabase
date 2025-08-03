//
//  MovieRemoteDataSource.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/3/25.
//
import Foundation

protocol MovieRemoteDataSource {
    func fetchMovies(for timePeriod: String) async throws -> Data
    func fetchMovieDetails(for movieId: Int) async throws -> Data
}

class TMDBMovieRemoteDataSource: MovieRemoteDataSource {
    
    func fetchMovies(for timePeriod: String) async throws -> Data {
        let url = URL(string: "https://api.themoviedb.org/3/trending/movie/\(timePeriod)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDBApiKey") as? String
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(apiKey!)"
        ]
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        } catch {
            throw MovieError.from(error)
        }
        
    }
    func fetchMovieDetails(for movieId: Int) async throws -> Data {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDBApiKey") as? String
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(apiKey!)"
        ]
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        } catch {
            throw MovieError.from(error)
        }
    }
}
