//
//  MovieResponse.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 29.10.2025.
//

import UIKit

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String
}
