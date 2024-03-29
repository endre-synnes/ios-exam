//
//  FavoritesViewController.swift
//  Swars
//
//  Resources used in this file: https://cocoacasts.com/populate-a-table-view-with-nsfetchedresultscontroller-and-swift-3

import UIKit
import CoreData

class FavoritesViewController: UIViewController {

    // Variables
    
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
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    fileprivate lazy var movieFetchedResultsController: NSFetchedResultsController<MovieEntity> = {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "episode_id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    // Class functions
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try self.characterFetchedResultsController.performFetch()
            try self.movieFetchedResultsController.performFetch()
            findRecommendationMovie()
        } catch {
            _ = error as NSError
            print("Unable to Perform Fetch Request")
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.title = "Favorites"
        selectedState = SegmentStatus.movies
        
        setUpView()
        createCustomViewAndSetDelegate()
    }
    
    // Helper functions
    
    private func setUpView(){
        
        fetchDabaseData()
        
        if(Helper.app.isInternetAvailable()){
            loadMoviesFromServer { (movies) in
                self.movies = movies
                self.movies = self.movies.sorted{ $0.episode_id < $1.episode_id}
                DispatchQueue.main.async {
                    self.findRecommendationMovie()
                }
            }
        } else {
            viewErrorAlert(title: "No internet connection!", message: "Ensure that WiFi or cellular is enabled.")
        }
    }
    
    private func fetchDabaseData(){
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                do {
                    try self.characterFetchedResultsController.performFetch()
                    try self.movieFetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                    self.viewErrorAlert(title: "Database error", message: "Unable to fetch data.")
                }
            }
        }
    }
    
    private func viewErrorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {action in
            self.viewDidLoad()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true)
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
                    if movie.episode_id == value {
                        resultMovie = movie
                    }
                }
                updateReccomended(movie: resultMovie)
            }
        } else {
            updateReccomended(movie: nil)
        }
    }
    
    private func updateReccomended(movie : Movie?){
        if movie != nil {
            self.recommendedView.isHidden = false
            self.updateRecommendedDelegate.update(headerTxt: "\(recomendationTexts.randomElement()!):", descriptionText: movie!.title )
        } else {
            self.recommendedView.isHidden = true
        }
    }
    
    private func createCustomViewAndSetDelegate() {
        self.recommendedView = RecommendedView.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height - 150, width: UIScreen.main.bounds.width, height: 150))
        self.recommendedView.isHidden = true
        self.updateRecommendedDelegate = recommendedView
        self.view.addSubview(recommendedView)
    }
    
    
    // Segue functions
    
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
                    let alert = UIAlertController(title: "Movie not found!", message: "The movie details is not yet loaded from the API, try again", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func deleteFavoriteCharacter(indexPath: IndexPath){
        let character = characterFetchedResultsController.object(at: indexPath)
        character.managedObjectContext?.delete(character)
        
        persistentContainer.viewContext.delete(character)
         do {
            try persistentContainer.viewContext.save()
        } catch {
            print("failed to save")
        }
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
