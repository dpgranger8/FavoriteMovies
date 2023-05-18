//
//  FavoritesViewController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/3/22.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    @IBAction func EditButton(_ sender: Any) {
        tableView.isEditing.toggle()
    }
    
    private let movieController = MovieController.shared
    private var datasource: UITableViewDiffableDataSource<Int, Movie>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        if let movies = movieController.retrieveFavoriteMovies() {
            applyNewSnapshot(from: movies)
        }
        
        tableView.delegate = self
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if editingStyle == .delete {
            // Fetch the movie to delete
            if let movieToDelete = self.datasource.itemIdentifier(for: indexPath) {
                movieController.removeFavoriteMovie(movieToDelete)
                
                // Update the snapshot
                tableView.deleteRows(at: [indexPath], with: .fade)
                var snapshot = self.datasource.snapshot()
                snapshot.deleteItems([movieToDelete])
                self.datasource.apply(snapshot, animatingDifferences: true)
            }
        }
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }*/
}

private extension FavoritesViewController {
    
    func setUpTableView() {
        tableView.backgroundView = backgroundView
        setUpDataSource()
        tableView.register(UINib(nibName: MovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
    
    func setUpDataSource() {
        datasource = UITableViewDiffableDataSource<Int, Movie>(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier) as! MovieTableViewCell
            cell.update(with: APIMovie(from: movie), onFavorite: {})
            return cell
        }
    }
    
    func applyNewSnapshot(from movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(movies)
        datasource?.apply(snapshot, animatingDifferences: true)
        tableView.backgroundView = movies.isEmpty ? backgroundView : nil
    }
    
    func reload(_ movie: Movie) {
        var snapshot = datasource.snapshot()
        snapshot.reloadItems([movie])
        datasource?.apply(snapshot, animatingDifferences: true)
    }
}
