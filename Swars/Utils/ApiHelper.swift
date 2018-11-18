//
//  ApiHelper.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 11/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import Foundation

func loadDataFromServer(requestCompleted: @escaping (_ movies: [Movie]) -> ()) {
    let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/films/?format=json")!) { (data, response, error) in
        
        if let actualData = data {
            
            _ = String.init(data: actualData, encoding: String.Encoding.utf8)
            
            let decoder = JSONDecoder()
            
            do {
                let movieResponse = try decoder.decode(MovieResponse.self, from: actualData)
                //   self.movies = movieResponse.results
                //  self.movies = self.movies.sorted{ $0.episode_id < $1.episode_id}
                requestCompleted(movieResponse.results)
            } catch let error {
                print(error)
            }
            
        }
    }
    
    task.resume()
}
