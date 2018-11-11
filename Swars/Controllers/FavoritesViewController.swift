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
        let index = sender.selectedSegmentIndex
        
        if index == 0 {
            selectedState = SegmentStatus.movies
        } else {
            selectedState = SegmentStatus.characters
        }
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    enum SegmentStatus {
        case movies
        case characters
    }
    
    var selectedState : SegmentStatus!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        self.navigationItem.title = "Favorites"

        loadDatabase()
        selectedState = SegmentStatus.movies
        
        let nib = UINib(nibName: "CharacterTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "characterTableCell")
        
    }
    
    func loadDatabase() {
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        
        let fetchCharactersRequest = NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
        favoriteCharacters = try! context.fetch(fetchCharactersRequest)
        
        let fetchMoviesRequest = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        favoriteMovies = try! context.fetch(fetchMoviesRequest)
        
        tableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedState == SegmentStatus.movies {
            return favoriteMovies.count
        }
        return favoriteCharacters.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterTableCell") as! FavoriteTableViewCell
        
        if selectedState == SegmentStatus.movies {
            cell.customInit(name: self.favoriteMovies[indexPath.row].title ?? "nil")
        } else {
            let character = self.favoriteCharacters[indexPath.row]
            cell.customInit(name: character.name ?? "nil", movies: character.movies ?? "nil")
        }
        
        return cell

    }
    
}
