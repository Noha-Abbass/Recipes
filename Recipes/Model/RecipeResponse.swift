//
//  RecipeResponse.swift
//  Recipes
//
//  Created by noha abbass on 8/23/22.
//

import Foundation

struct RecipeResponse : Codable {
    let hits : [Recipe]
    let more : Bool
    let from : Int
    let to : Int
    let count : Int
}


struct Recipe : Codable {
    let recipe : RecipeItem
}
