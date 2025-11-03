//
//  MovieResponse.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 29.10.2025.
//

import Foundation

struct MovieResponse: Codable, Hashable {
    let results: [Movie]
}

struct Movie: Codable, Hashable {
    let title: String
    let posterPath: String?
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let releaseDate: String
    let genreIds: [Int]
    let popularity: Double
    let voteAverage: Double
    let overview: String
    let video: Bool
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
     }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var fullPosterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case video
    }
}
