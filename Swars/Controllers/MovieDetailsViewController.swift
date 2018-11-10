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
    
    //@IBOutlet weak var favoriteBtn: UIButton!
    
    @IBAction func favoriteBtn(_ sender: UIButton) {
        //sender.setTitle("buttonName", forState: .normal)
        
        if checkForFavorite() {
            sender.setTitle("Remove from Favorites", for: .normal)
        } else {
            sender.setTitle("Add to Favorites", for: .normal)
        }
        
        btnPresed()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movie?.title
        

        //favoriteBtn.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)

        //self.buttonPressed(sender: self.favoriteBtn)

        movieTitleLabel.text = "Title: \(movie?.title ?? "")"
        directorLabel.text = "Director: \(movie?.director ?? "")"
        producerLabel.text = "Producer: \(movie?.producer ?? "")"
        releaseDateLabel.text = "Release date: \(movie?.release_date ?? "")"
    
    }
    
    func checkForFavorite() -> Bool {
        loadDatabase(action: DbAction.get)
        
        if myFavorites.contains(where: {$0.title == movie?.title}) {
            //favoriteBtn.setTitle("Remove from Favorites", for: .normal)
            //loadDatabase(action: DbAction.delete)
            // delete
            return true
        } else {
            //favoriteBtn.setTitle("Add to Favorite", for: .normal)
            //loadDatabase(action: DbAction.add)
            return false
        }
        
    }
    
    func btnPresed(){
        print("btn pressed")
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
        
        if(movie?.title == nil || movie?.episode_id == nil){
            return
        }
        
        if action == DbAction.add {
            let movieDict = [ "title" : movie!.title,
                              "episode_id" : movie!.episode_id] as [String : Any]
            
            _ = CharacterEntity.init(attributes: movieDict, managedObjectContext: context)
            delegate.saveContext()
            
        } else if action == DbAction.delete {
            if let favorite = myFavorites.first(where: {$0.title == movie!.title}) {
                context.delete(favorite)
                delegate.saveContext()
            } else {
                print("Favorite not found")
                return
            }
        }
        
    }
    
    /*
    @IBAction func buttonPressed(sender: AnyObject) {
        //println("Called Action"). This method has been renamed to print() in Swift 2.0
        print("Called Action")
    }
     */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
