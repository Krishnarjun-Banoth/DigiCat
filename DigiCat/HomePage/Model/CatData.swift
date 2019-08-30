//
//  CatsBrowseOptionsVC.swift
//  DigiCat
//
//  Created by Krishnarjun on 26/08/19.
//  Copyright © 2019 Krishnarjun. All rights reserved.
//

import Foundation


struct CatData: Codable {
    var id: String
    var url: String
    var categories : [Category]?
    var breeds : [Breed]?
}


struct Category: Codable {
    var id: Int64
    var name: String
}

struct Breed: Codable {
    var id: String
    var name: String
    var temperament: String
    var lifeSpan: String
    var altNames: String
    var wikipediaUrl: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case temperament = "temperament"
        case lifeSpan = "life_span"
        case altNames = "alt_names"
        case wikipediaUrl = "wikipedia_url"
        case description = "description"
    
    }
}
