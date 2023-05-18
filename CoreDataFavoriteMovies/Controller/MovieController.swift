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
    
    func createFavoriteMovie(_ movie: APIMovie) {
        let coreDataMovie = Movie(context: PersistenceController.shared.viewContext)
        
        coreDataMovie.imdbID = movie.imdbID
        coreDataMovie.title = movie.title
        coreDataMovie.year = movie.year
        coreDataMovie.posterURL = movie.posterURLString
        
        PersistenceController.shared.saveContext()
    }
    
    func retrieveFavoriteMovies() -> [Movie]? {
        do {
            let moviesArray = try PersistenceController.shared.viewContext.fetch(Movie.fetchRequest())
            return moviesArray
        } catch {
            print("Failed to fetch movies from CoreData: \(error)")
            return nil
        }
    }
    
    func removeFavoriteMovie(_ movie: Movie) {
        PersistenceController.shared.viewContext.delete(movie)
        PersistenceController.shared.saveContext()
    }
}
