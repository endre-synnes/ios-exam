//
//  MovieDetailsViewController.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 09/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailsViewController: UIViewController {

    var movie : Movie?
    var myFavorites = [MovieEntity]()
    enum DbAction {
        case get
        case add
        case delete
    }
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var favoriteBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movie?.title
    
        favoriteBtnOutlet.addTarget(self, action: #selector(MovieDetailsViewController.btnPresed), for: .touchUpInside)
        _ = checkForFavorite()

        movieTitleLabel.text = "Title: \(movie?.title ?? "")"
        directorLabel.text = "Director: \(movie?.director ?? "")"
        producerLabel.text = "Producer: \(movie?.producer ?? "")"
        releaseDateLabel.text = "Release date: \(movie?.release_date ?? "")"
    
    }
    
    func checkForFavorite() -> Bool {
        loadDatabase(action: DbAction.get)
        
        if myFavorites.contains(where: {$0.title == movie?.title}) {
            favoriteBtnOutlet.setTitle("Remove from Favorites", for: .normal)
            return true
        } else {
            favoriteBtnOutlet.setTitle("Add to Favorite", for: .normal)
            return false
        }
        
    }
    
    @objc func btnPresed(){
        if checkForFavorite() {
            loadDatabase(action: DbAction.delete)
        } else {
            loadDatabase(action: DbAction.add)
        }
    }
    
    func loadDatabase(action : DbAction) {
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        myFavorites = try! context.fetch(fetchRequest)
        
        if(movie?.title == nil || movie?.url == nil){
            return
        }
        
        if action == DbAction.add {
            
            let movieStrArray = movie?.url.components(separatedBy: "/")
            if movieStrArray!.count < 3 {return}
            
            let movieDict = [ "title" : movie!.title,
                              "episode_id" : Int(movieStrArray![movieStrArray!.count - 2])] as [String : Any]
            
            _ = MovieEntity.init(attributes: movieDict, managedObjectContext: context)
            delegate.saveContext()
            self.viewDidLoad()
            
        } else if action == DbAction.delete {
            if let favorite = myFavorites.first(where: {$0.title == movie!.title}) {
                context.delete(favorite)
                delegate.saveContext()
                self.viewDidLoad()
            } else {
                print("Favorite not found")
                return
            }
        }
    }
}
