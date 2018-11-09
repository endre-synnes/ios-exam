//
//  Character.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 08/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import Foundation

class CharacterResponse : Decodable {
    let count: Int
    let results: Array<Character>
}

class Character : Decodable{
    
    let name: String
    let height: String
    let hair_color: String
    let birth_year: String
    let gender: String
    let films: Array<String>
    let url: String
}
