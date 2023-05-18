//
//  MovieAPIController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

class MovieAPIController {
    
    enum FetchItemsError: Error, LocalizedError {
        case invalidStatusCode
    }
    
    let baseURL = URL(string: "http://www.omdbapi.com/")!
    let apiKey = "e718dfd9"
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        let searchItem = URLQueryItem(name: "s", value: searchTerm)
        let apiKeyItem = URLQueryItem(name: "apiKey", value: apiKey)
        let url = baseURL.appending(queryItems: [apiKeyItem, searchItem])
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard response is HTTPURLResponse else {
            throw FetchItemsError.invalidStatusCode
        }
        
        let jsonDecoder = JSONDecoder()
        let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
        
        return searchResponse.movies
    }
    
}
