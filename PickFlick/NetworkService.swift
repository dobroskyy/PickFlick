//
//  NetworkService.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 29.10.2025.
//

import UIKit

class NetworkService {

    let token = APIConfig.tmdbToken

    func buildingURL() -> URL? {
        var components = URLComponents(string: "https://api.themoviedb.org/3/movie/popular")
        components?.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        return components?.url
    }
    
    
    func request() throws -> URLRequest {
        guard let url = buildingURL() else {
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
    
    func fetchData() async throws -> Data {
        let req = try request()
        let (data, _) = try await URLSession.shared.data(for: req)
        print(String(decoding: data, as: UTF8.self))
        
        return data
        
    }
    
    func fetchMovieTitles() async throws -> [String] {
        let data = try await fetchData()
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        return response.results.map { $0.title }
    }
    
        
}

