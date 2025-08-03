//
//  DetailMovieModel.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/4/25.
//

import Foundation
import SwiftData

@Model
class DetailMovieModel: Identifiable {
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String?
    var backdropPath: String?
    var runtime: Int
    var genres: [Genre]
    var originCountry: [String]
    var productionCompanies: [ProductionCompany]
    
    var isFavorite: Bool

    init(
        id: Int,
        title: String,
        overview: String,
        backdropPath: String? = nil,
        releaseDate: String? = nil,
        isFavorite: Bool = false,
        runtime: Int,
        genres: [Genre] = [],
        originCountry: [String]? = nil,
        productionCompanies: [ProductionCompany] = []
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.isFavorite = isFavorite
        self.runtime = runtime
        self.genres = genres
        self.originCountry = originCountry ?? []
        self.productionCompanies = productionCompanies
        
    }
}
struct Genre: Codable,Identifiable {
    let id: Int
    let name: String
}
struct ProductionCompany: Codable, Identifiable {
    let id: Int
    let name: String
}

struct GenreTO: Codable {
    let id: Int
    let name: String
}

struct ProductionCompanyTO: Codable {
    let id: Int
    let name: String
}

struct DetailMovieTransferObject: Codable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let backdropPath: String?
    let releaseDate: String?
    let genres: [Genre]
    let originCountry: [String]?
    let productionCompanies: [ProductionCompany]
    let runtime: Int
}
