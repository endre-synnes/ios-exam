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
    var myFavorites = [CharacterEntity]()
    let apiUrl = "https://swapi.co/api/people/?page="
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    
        //self.reloadCollectionView()
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
        myFavorites = try! context.fetch(fetchRequest)
        
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
        
        // Do any additional setup after loading the view.
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
        print("selected name: \(character.name)")
        
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
      
        for favorite in myFavorites{
            if (favorite.name == character.name){
                context.delete(favorite)
                delegate.saveContext()
                collectionView.reloadData()
                self.viewDidLoad()
                return
            }
        }
        
        var tmpStringArray = [String]()
        
        for movie in character.films {
            let movieStrArray = movie.components(separatedBy: "/")
            if movieStrArray.count < 3 {continue}
            
            tmpStringArray.append(movieStrArray[movieStrArray.count - 2])
        }
        
        let movies = tmpStringArray.sorted().joined(separator: ",")
        
        let charDict = [ "name" : character.name,
                         "url" : character.url,
                         "movies" : movies] as [String : Any]
        
        _ = CharacterEntity.init(attributes: charDict, managedObjectContext: context)
        delegate.saveContext()
        self.viewDidLoad()
        return
        
        
        
    }
    
    /*
    func reloadCollectionView() {
        let delegate =  (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
        myFavorites = try! context.fetch(fetchRequest)
        print("Size after reload: \(myFavorites.count)")
        self.viewDidLoad()
    }
 */

    
    func loadDataFromServer() {
        characters.removeAll()
        
        for index in 1...3 {
            
            let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/people/?page=\(index)&format=json")!) { (data, response, error) in
                
                if let actualData = data {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let characterResponse = try decoder.decode(CharacterResponse.self, from: actualData)
                        
                        self.characters.append(contentsOf: characterResponse.results)
                        self.characters = self.characters.sorted{ $0.name < $1.name}
                        //self.characters = characterResponse.results
                        
                        //Siden kun main thread har lov til å gjøre UI opdpateringer så må man få tilgang til main thread og så kjøre kode på den for å oppdatere UI.
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                        
                    } catch let error {
                        print(error)
                    }
                    
                }
            }
            
            task.resume()
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
