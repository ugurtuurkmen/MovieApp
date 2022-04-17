//
//  MovieModel.swift
//  MovieApp
//
//  Created by UgurTurkmen on 17.04.2022.
//

import Foundation

struct MovieModel : Codable {
    let results : [Movie]
}


struct Movie : Codable {
    let id : Int
    let poster_path : String
    let overview : String
    let original_title : String
    let vote_average : Double
    let release_date : String
}
