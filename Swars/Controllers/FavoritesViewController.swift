//
//  FavoritesViewController.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 08/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {

    //var favoriteMovies = [MovieEntity]()
    //var favoriteCharacters = [CharacterEntity]()
    var movies = [Movie]()
    let recomendationTexts = ["Jar Jar’s Top 1-list", "Jabbas Favorite",
                              "Yoda you have to see this!", "C3PO´s number 1",
                              "Bobafets Recomendation", "Lukes Sisters Favorite"]

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
    

    private let persistentContainer = NSPersistentContainer(name: "SwarsRepository")


    fileprivate lazy var characterFetchedResultsController: NSFetchedResultsController<CharacterEntity> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    fileprivate lazy var movieFetchedResultsController: NSFetchedResultsController<MovieEntity> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "episode_id", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadDatabase()
        findRecommendationMovie()
        do {
            try self.characterFetchedResultsController.performFetch()
            try self.movieFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
        }
        tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self.setupView()
                
                do {
                    try self.characterFetchedResultsController.performFetch()
                    try self.movieFetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                
                self.updateView()
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self

        self.navigationItem.title = "Favorites"
        
        if(Helper.app.isInternetAvailable()){
            loadMoviesFromServer { (movies) in
                self.movies = movies
                self.movies = self.movies.sorted{ $0.episode_id < $1.episode_id}
                DispatchQueue.main.async {
                    self.findRecommendationMovie()
                }
            }
        } else {
            let alert = UIAlertController(title: "No internet connection!", message: "Ensure that WiFi or cellular is enabled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        //loadDatabase()
        selectedState = SegmentStatus.movies
        createCustomViewAndSetDelegate()
    }
    
    private func setupView() {
        //setupMessageLabel()
        
        updateView()
    }
    
    private func updateView() {
        var hasEntities = false
        
        if let characters = characterFetchedResultsController.fetchedObjects {
            hasEntities = characters.count > 0
        }
        if let movies = movieFetchedResultsController.fetchedObjects {
            hasEntities = movies.count > 0
        }
        
        if !hasEntities {
            print("no entities found")
        }
        
        //tableView.isHidden = !hasQuotes
        //messageLabel.isHidden = hasQuotes
        
        //activityIndicatorView.stopAnimating()
    }
    
    func findRecommendationMovie() {
        var resultMovie: Movie?
        
        var movieOrruranseArray = [Int]()
        
        let favoriteCharacters = characterFetchedResultsController.fetchedObjects
        
        if favoriteCharacters == nil {
            return
        }
        
        for character in favoriteCharacters! {
            if(character.movies == nil){
                continue
            }
            
            for movie in (character.movies?.split(separator: ",").map {Int($0)})! {
                if(movie == nil){
                    continue
                }
                movieOrruranseArray.append(movie!)
            }
        }
        
        if (!movieOrruranseArray.isEmpty){
            let counts = movieOrruranseArray.reduce(into: [:]) { $0[$1, default: 0] += 1 }
            
            // https://stackoverflow.com/questions/38416347/getting-the-most-frequent-value-of-an-array
            if let (value, _) = counts.max(by: { $0.1 < $1.1 }) {
                for movie in movies {
                    if movie.url.range(of: String(value)) != nil {
                        resultMovie = movie
                    }
                }
                updateReccomended(movie: resultMovie)
            }
        }
    }
    
    private func updateReccomended(movie : Movie?){
        if movie != nil {
            self.recommendedView.isHidden = false
            self.updateRecommendedDelegate.update(headerTxt: "\(recomendationTexts.randomElement()!):", descriptionText: movie!.title )
        }
    }
    
    private func createCustomViewAndSetDelegate() {
        self.recommendedView = RecommendedView.init(frame: CGRect.init(x: 0, y: tableView.bounds.height + 30, width: UIScreen.main.bounds.width, height: 60))
        self.recommendedView.isHidden = true
        self.updateRecommendedDelegate = recommendedView
        self.view.addSubview(recommendedView)
    }
    
    /*
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
        if selectedState == SegmentStatus.movies {
            self.tableView.deselectRow(at: indexPath, animated: true)
            let objectThtatWasTapped = favoriteMovies[indexPath.row]
            self.performSegue(withIdentifier: "segueFromFavoriteToMovie", sender: objectThtatWasTapped)
        } else {
            let character = favoriteCharacters[indexPath.row]
            let alert = UIAlertController(title: "\(character.name ?? "") was in:", message: "\(getMovieTitlesByCharacter(characterUrl: character.url ?? ""))", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: {action in
                self.deleteFavoriteCharacter(character: character)
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
    */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if selectedState == SegmentStatus.movies {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedState == SegmentStatus.movies {
            if let destination = segue.destination as? MovieDetailsViewController, let transferObject = sender as? MovieEntity {
                if let movie = movies.first(where: {$0.episode_id == Int(transferObject.episode_id)}) {
                    destination.movie = movie
                } else {
                    let alert = UIAlertController(title: "Movie not found!", message: "Your favorite movie is not found in our API", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func deleteFavoriteCharacter(indexPath: IndexPath){
        
        /*

        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        
        let context = delegate.persistentContainer.viewContext
        
        context.delete(character)
        delegate.saveContext()
         */
        //loadDatabase()
        let character = characterFetchedResultsController.object(at: indexPath)
        
        // Delete Quote
        character.managedObjectContext?.delete(character)

        self.viewWillAppear(false)
    }
    
    private func getMovieTitlesByCharacter(characterUrl : String) -> String {
        var moviesByCharacter = ""
        
        for movie in movies {
            if movie.characters.contains(where: { $0 == characterUrl}){
                moviesByCharacter.append("\(movie.title), ")
            }
        }
        
        if moviesByCharacter.last == " " {
            moviesByCharacter = String(moviesByCharacter.dropLast())
            return String(moviesByCharacter.dropLast())
        }
        return moviesByCharacter
    }
    
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedState == SegmentStatus.movies {
            guard let movies = movieFetchedResultsController.fetchedObjects else { return 0 }
            return movies.count
        }
        guard let characters = characterFetchedResultsController.fetchedObjects else { return 0 }
        return characters.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTableCell") as! FavoriteTableViewCell
        
        if selectedState == SegmentStatus.movies {
            
            let movie = movieFetchedResultsController.object(at: indexPath)
            cell.customInit(name: movie.title ?? "nil")
        } else {
            let character = characterFetchedResultsController.object(at: indexPath)
            cell.customInit(name: character.name ?? "nil", movies: character.movies ?? "nil")
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
}


extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedState == SegmentStatus.movies {
            self.tableView.deselectRow(at: indexPath, animated: true)
            let objectThtatWasTapped = movieFetchedResultsController.object(at: indexPath)
            self.performSegue(withIdentifier: "segueFromFavoriteToMovie", sender: objectThtatWasTapped)
        } else {
            let character = characterFetchedResultsController.object(at: indexPath)
            let alert = UIAlertController(title: "\(character.name ?? "") was in:", message: "\(getMovieTitlesByCharacter(characterUrl: character.url ?? ""))", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: {action in
                self.deleteFavoriteCharacter(indexPath: indexPath)
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
}
