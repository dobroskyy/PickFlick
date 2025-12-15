//
//  MovieHistoryManager.swift
//  PickFlick
//
//  Created by max on 15.12.2025.
//

import Foundation

class MovieHistoryManager {
    
    static let shared = MovieHistoryManager()
    
    private init() {
    }
    
    private var history: [ViewedMovie] = []

    func getHistory() -> [ViewedMovie] {
        return history
    }
    
    func saveViewedMovie(_ movie: ViewedMovie) {
        guard !history.contains(where: { $0.movie.id == movie.movie.id }) else {
            return
        }
        history.append(movie)
    }
    
    func deleteMovie(_ movie: ViewedMovie) {
        history.removeAll(where: { $0.movie.id == movie.movie.id })
    }
    
    func deleteAll() {
        history.removeAll()
    }
}
