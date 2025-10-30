//
//  NetworkService.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 29.10.2025.
//

import Foundation

class NetworkService {

    let token = APIConfig.tmdbToken
    var language: String = "en-US"
    var category: String = "popular"
    

    func makeURL(page: Int = 1) -> URL? {
        var components = URLComponents(string: "https://api.themoviedb.org/3/movie/\(self.category)")
         components?.queryItems = [
            URLQueryItem(name: "language", value: self.language),
             URLQueryItem(name: "page", value: "\(page)")
         ]
        return components?.url
    }
    
    
    func makeRequest(page: Int = 1) throws -> URLRequest {
        guard let url = makeURL(page: page) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(token)"
        ]
        
        return request
        
    }
    
    func fetchMovieData(page: Int = 1) async throws -> Data {
        let req = try makeRequest(page: page)
        let (data, _) = try await URLSession.shared.data(for: req)
        return data
        
    }
    
    func decodeMovieResponse(from data: Data) throws -> MovieResponse {
         return try JSONDecoder().decode(MovieResponse.self, from: data)
     }
    
    func fetchMovies(pageCount: Int = 10) async throws -> [Movie] {
        var allMovies: [Movie] = []
        
        for page in 1...pageCount {
            let data = try await fetchMovieData(page: page)
            let response = try decodeMovieResponse(from: data)
            allMovies.append(contentsOf: response.results)
        }
        
        return allMovies
    }
        
}

 
