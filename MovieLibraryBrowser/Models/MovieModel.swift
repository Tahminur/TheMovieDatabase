//
//  MovieModel.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/2/25.
//

import Foundation
import SwiftData

@Model
class MovieModel {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var releaseDate: String?
    var posterPath: String?
    var isFavorite: Bool
    var voteAverage: Double
    var lastCachedDate: Date?

    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String? = nil,
        releaseDate: String? = nil,
        isFavorite: Bool = false,
        voteAverage: Double,
        lastCachedDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.isFavorite = isFavorite
        self.voteAverage = voteAverage
        self.lastCachedDate = lastCachedDate
    }
}
extension MovieModel {
    var isStale: Bool {
        guard let lastCachedDate else { return true }
        return Date().timeIntervalSince(lastCachedDate) > 86400 // 24 hours
    }
}
struct MovieResponse: Codable, Sendable {
    let results: [MovieTransferObject]
}

struct MovieTransferObject: Codable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
}
