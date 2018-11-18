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
    var movies = [Movie]()
    
    func findRecommendationMovie() {
        
        /*
        var resultMovie: MovieEntity?
        
        for character in favoriteCharacters {
            for movie in (character.movies?.split(separator: ","))! {
                
                for movieEnti in favoriteMovies {
                    if movieEnti.episode_id == movie
                }
            }
        }
        
        for movie in favoriteMovies {
            for character in movie.characters {
                
                for favChar in favoriteCharacters {
                    
                }
                
            }
        }
        */
        updateRecommendedDelegate.update(headerTxt: "new value", descriptionText: "new value")
    }
    
    private var updateRecommendedDelegate: UpdateRecommendationView!
    private var recommendedView: RecommendedView!

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
        
        loadDataFromServer { (movies) in
            self.movies = movies
            self.movies = self.movies.sorted{ $0.episode_id < $1.episode_id}
        }
        loadDatabase()
        selectedState = SegmentStatus.movies
        createCustomViewAndSetDelegate()
        //let nib = UINib(nibName: "CharacterTableViewCell", bundle: nil)
        //tableView.register(nib, forCellReuseIdentifier: "characterTableCell")
        
    }
    
    //For oppdatering
    //Kall self.updateRecommendedDelegate.update(headerTxt: "HEADER TEST", descriptionText: "DESC TEST")
    
    private func createCustomViewAndSetDelegate() {
        self.recommendedView = RecommendedView.init(frame: CGRect.init(x: 0, y: tableView.bounds.height + 30, width: UIScreen.main.bounds.width, height: 60))
        self.recommendedView.isHidden = true
        self.updateRecommendedDelegate = recommendedView
        self.view.addSubview(recommendedView)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTableCell") as! FavoriteTableViewCell
        
        if selectedState == SegmentStatus.movies {
            cell.customInit(name: self.favoriteMovies[indexPath.row].title ?? "nil")
        } else {
            let character = self.favoriteCharacters[indexPath.row]
            cell.customInit(name: character.name ?? "nil", movies: character.movies ?? "nil")
            cell.selectionStyle = .none

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did hit did select for index: \(indexPath)")
        print("MOVIE STATUS: \(selectedState.debugDescription)")
        if selectedState == SegmentStatus.movies {
            self.tableView.deselectRow(at: indexPath, animated: true)
            let objectThtatWasTapped = favoriteMovies[indexPath.row]
            self.performSegue(withIdentifier: "segueFromFavoriteToMovie", sender: objectThtatWasTapped)
        } else {
            let character = favoriteCharacters[indexPath.row]
            
            let movies = character.movies
            
            let alert = UIAlertController(title: "\(character.name ?? "Name not defined")", message: "\(movies ?? "No mvoies")", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Remove Favorite", style: .default, handler: {action in
                //self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        return footerView
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if selectedState == SegmentStatus.movies {
            return true
        }
        print("in false")
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if selectedState == SegmentStatus.movies {
        
        
            print("in favorite prepare")
            if let destination = segue.destination as? MovieDetailsViewController, let transferObject = sender as? MovieEntity {
                
                print("lopping movies")
                for i in movies {
                    print("episode ids: \(i.episode_id)")
                }
                
                print("selected: \(transferObject.episode_id)")
                
                if let movie = movies.first(where: {$0.episode_id == Int(transferObject.episode_id)}) {
                    
                    print("in equal...... ")
                    
                    destination.movie = movie
                } else {
                    let alert = UIAlertController(title: "Movie not found!", message: "Your favorite movie is not found in our API", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    
    }
    
    
}
