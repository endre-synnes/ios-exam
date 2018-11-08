//
//  Movie.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 08/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import Foundation

class MovieResponse : Decodable {
    let count: Int
    let results: Array<Movie>
}

class Movie : Decodable{
    
    let title: String
    let episode_id: Int
    let director: String
    let release_date: String
    let producer: String
    let characters: Array<String>
}
