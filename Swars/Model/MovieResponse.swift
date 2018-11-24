//
//  Movie.swift
//  Swars

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
    let url: String
}
