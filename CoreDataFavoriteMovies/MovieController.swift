//
//  MovieController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

class MovieController {
    static let shared = MovieController()
    private let apiController = MovieAPIController()
    private var viewContext = PersistenceController.shared.viewContext
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        return try await apiController.fetchMovies(with: searchTerm)
    }
    
    func favoriteMovie(_ movie: APIMovie) {
        let newMovie = Movie(context: viewContext)
        newMovie.title = movie.title
        newMovie.imdbID = movie.imdbID
        newMovie.year = movie.year
        newMovie.createdAt = Date()
        newMovie.favoritedAt = nil
        newMovie.posterURLString = movie.posterURL?.absoluteString
        PersistenceController.shared.saveContext()
    }
    
    func unFavoriteMovie(_ movie: Movie) {
        viewContext.delete(movie)
        PersistenceController.shared.saveContext()
    }
    
    func favoriteExists(for movie: APIMovie) -> Bool {
        let fetchRequest = Movie.fetchRequest()
        let predicate = NSPredicate(format: "imdbID == %@", movie.id)
        fetchRequest.predicate = predicate
        let count = try? viewContext.count(for: fetchRequest)
        return (count ?? 0) > 0
    }
    
    func favoriteMovie(from movie: APIMovie) -> Movie? {
        let fetchRequest = Movie.fetchRequest()
        let predicate = NSPredicate(format: "imdbID == %@", movie.id)
        fetchRequest.predicate = predicate
        return try? viewContext.fetch(fetchRequest).first
    }
    
}
