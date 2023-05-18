//
//  APIMovie.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/5/22.
//

import Foundation

struct SearchResponse: Decodable {
    let movies: [APIMovie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}

struct APIMovie: Codable, Identifiable, Hashable {
    let title: String
    let year: String
    let imdbID: String
    let posterURLString: String
    
    var id: String { imdbID }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case posterURLString = "Poster"
    }
}

extension APIMovie {
    var posterURL: URL? {
        return URL(string: posterURLString)
    }
}

extension APIMovie {
    init(from movie: Movie) {
        self.title = movie.title ?? ""
        self.year = movie.year ?? ""
        self.imdbID = movie.imdbID ?? ""
        self.posterURLString = movie.posterURL ?? ""
    }
}
