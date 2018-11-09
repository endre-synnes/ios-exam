//
//  CharactersViewController.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 08/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var characters = [Character]()
    let apiUrl = "https://swapi.co/api/people/?page="
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        if(Helper.app.isInternetAvailable()){
            for index in 1...3 {
                loadDataFromServer(index: index)
            }
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
        
        cell.characterNameLabel.text = characters[indexPath.item].name
        cell.characterImageView.backgroundColor = UIColor.black
        
        //TODO implement check for database
        
        return cell
        
    }
    

    
    func loadDataFromServer(index: Int) {
        let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/people/?page=\(index)&format=json")!) { (data, response, error) in
            
            if let actualData = data {
                                
                let decoder = JSONDecoder()
                
                do {
                    let characterResponse = try decoder.decode(CharacterResponse.self, from: actualData)
                    
                    self.characters.append(contentsOf: characterResponse.results)
                    
                    //self.characters = characterResponse.results
                    
                    //Siden kun main thread har lov til å gjøre UI opdpateringer så må man få tilgang til main thread og så kjøre kode på den for å oppdatere UI.
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                    for character in characterResponse.results {
                        print(character.name)
                    }
                } catch let error {
                    print(error)
                }
                
            }
        }
        
        task.resume()
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
