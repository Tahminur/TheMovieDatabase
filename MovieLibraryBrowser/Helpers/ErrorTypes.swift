//
//  ErrorTypes.swift
//  MovieLibraryBrowser
//
//  Created by Tahminur Rahman on 7/3/25.
//

import Foundation

enum MovieError: Error, Identifiable {
    var id: String { localizedDescription }

    case networkFailure
    case decodingFailure
    case unknown

    var message: String {
        switch self {
        case .networkFailure: return "Failed to connect to server."
        case .decodingFailure: return "Invalid data from server."
        case .unknown: return "Something went wrong."
        }
    }

    static func from(_ error: Error) -> MovieError {
        // Map concrete errors to domain-specific errors
        if error is URLError {
            return .networkFailure
        } else if error is DecodingError {
            return .decodingFailure
        } else {
            return .unknown
        }
    }
}
