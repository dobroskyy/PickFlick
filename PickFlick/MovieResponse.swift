//
//  MovieResponse.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 29.10.2025.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
    let posterPath: String?
    
    var fullPosterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
    }
}
