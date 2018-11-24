//
//  ApiHelper.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 11/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import Foundation

func loadMoviesFromServer(requestCompleted: @escaping (_ movies: [Movie]) -> ()) {
    let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/films/?format=json")!) { (data, response, error) in
        if let actualData = data {
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: actualData)
                requestCompleted(movieResponse.results)
            } catch let error {
                print(error)
            }
            
        }
    }
    
    task.resume()
}

func loadCharactersFromServer(requestCompleted: @escaping (_ characters: [Character]) -> ()) {
    var characterArray = [Character]()
    var counter = 0
    for index in 1...3 {
        
        let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/people/?page=\(index)&format=json")!) { (data, response, error) in
            
            if let actualData = data {
                do {
                    counter += 1
                    let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: actualData)
                    
                    characterArray.append(contentsOf: characterResponse.results)
                    characterArray = characterArray.sorted{ $0.name < $1.name}
                    if(counter == 3){
                        requestCompleted(characterArray)
                    }
                } catch let error {
                    print(error)
                }
                
            }
        }
        
        task.resume()
    }
}
