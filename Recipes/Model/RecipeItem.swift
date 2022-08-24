//
//  RecipeItem.swift
//  Recipes
//
//  Created by noha abbass on 8/23/22.
//

import Foundation

struct RecipeItem : Codable {
    let image : String
    let label : String
    let source : String
    let healthLabels : [String]
    let ingredientLines : [String]
    let url : String
    let shareAs : String
}
