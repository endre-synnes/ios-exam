//
//  CharactersViewController.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 08/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import UIKit
import CoreData

class CharactersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var characters = [Character]()
    var movies = [Movie]()
    var myFavorites = [CharacterEntity]()
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
        myFavorites = try! context.fetch(fetchRequest)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.navigationItem.title = "Characters"

        loadDatabase()
        
        if(Helper.app.isInternetAvailable()){
            loadDataFromServer()
        } else {
            let alert = UIAlertController(title: "No internet connection!", message: "Ensure that WiFi or cellular is enabled.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {action in
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCollectionViewCell
        let name = characters[indexPath.item].name
        
        cell.characterNameLabel.text = name

        if myFavorites.contains(where: {$0.name == name}) {
            cell.characterImageView.backgroundColor = UIColor.orange
        } else {
            cell.characterImageView.backgroundColor = UIColor.black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.item]
        
        handleCellClick(character: character)
    }
    
    func handleCellClick(character: Character)  {
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        
        for favorite in myFavorites{
            if (favorite.name == character.name){
                context.delete(favorite)
                delegate.saveContext()
                collectionView.reloadData()
                return
            }
        }
        
        var tmpEpisodeIdArray = [String]()
        
        for movieUrl in character.films {
            tmpEpisodeIdArray.append(
                String((self.movies.first(where: {$0.url == movieUrl})?.episode_id)!)
            )
        }
        let movieIds = tmpEpisodeIdArray.sorted().joined(separator: ",")
        let charDict = [ "name" : character.name,
                         "url" : character.url,
                         "movies" : movieIds] as [String : Any]
        
        _ = CharacterEntity.init(attributes: charDict, managedObjectContext: context)
        delegate.saveContext()
        loadDatabase()
        collectionView.reloadData()
        return
    }
    
    func loadDatabase() {
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
        myFavorites = try! context.fetch(fetchRequest)
    }
    
    func loadDataFromServer() {
        characters.removeAll()
        
        loadMoviesFromServer { (movies) in
            self.movies = movies
            self.movies = self.movies.sorted{ $0.episode_id < $1.episode_id}
        }
        
        loadCharactersFromServer { (characters) in
            print("response")
            self.characters = characters
            self.characters = self.characters.sorted{ $0.name < $1.name}
            DispatchQueue.main.async {
                print("number in response: \(characters.count)")
                self.collectionView.reloadData()
            }
        }
    }
    

}
