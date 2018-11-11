//
//  FavoritesViewController.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 08/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    //this is the view
    var favoriteMovies = [MovieEntity]()
    var favoriteCharacters = [CharacterEntity]()

    @IBAction func switchFavoritesViewAction(_ sender: UISegmentedControl) {
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    enum SegmentStatus {
        case movies
        case characters
    }
    
    var selectedState : SegmentStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"

        loadDatabase()
        selectedState = SegmentStatus.movies
        
        let nib : UINib

        if selectedState == SegmentStatus.movies {
            nib = UINib(nibName: "MoviesTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "movieCell")
        } else {
            nib = UINib(nibName: "CharacterTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "characterTableCell")
        }

        // Do any additional setup after loading the view.
    }
    
    func loadDatabase() {
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        
        let fetchCharactersRequest = NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
        favoriteCharacters = try! context.fetch(fetchCharactersRequest)
        
        let fetchMoviesRequest = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        favoriteMovies = try! context.fetch(fetchMoviesRequest)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedState == SegmentStatus.movies {
            return favoriteMovies.count
        }
        return favoriteCharacters.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedState == SegmentStatus.movies {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MoviesTableViewCell
            cell.movieNameLabel.text = self.favoriteMovies[indexPath.row].title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "characterTableCell") as! CharacterTableViewCell
            let character = self.favoriteCharacters[indexPath.row]
            //TODO use movies...
            cell.customInit(name: character.name ?? "nil", movies: character.url ?? "nil")
            return cell
        }

    }
    
}
