//
//  RecipeSearchViewModel.swift
//  Recipes
//
//  Created by noha abbass on 8/23/22.
//

import Foundation

class RecipeSearchViewModel {
    var recipesList: [Recipe] = []
    var filteredList: [Recipe] = []
    var page = 0
    var filterPage = 0
    var nothingToShow = false
    var filterNothingToShow = false
    
    func getRecipes(query: String, onCompletion: @escaping (Bool)-> ()) {
        if !nothingToShow {
            APIService.shared.getAllRecipes(urlString: Constants.BASE_URL, query: query, healthFilter: nil, page: page) { (result) in
                switch result{
                case .success(let recipes):
                    if recipes.isEmpty {
                        print("nothing to show")
                        self.nothingToShow = true
                        onCompletion(false)
                    } else {
                        print("result: \(recipes)")
                        self.recipesList.append(contentsOf: recipes)
                        onCompletion(true)
                        self.page = self.page + 10
                    }
                    break
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    onCompletion(false)
                }
            }
        }
    }
    
    func getFilteredRecipes(query: String, filter: String, onCompletion: @escaping (Bool)->()) {
        if !filterNothingToShow {
            APIService.shared.getAllRecipes(urlString: Constants.BASE_URL, query: query, healthFilter: filter, page: filterPage) { (result) in
                switch result{
                case .success(let filteredRecipes):
                    if filteredRecipes.isEmpty {
                        print("nothing to show")
                        self.filterNothingToShow = true
                        onCompletion(false)
                    } else {
                        print("result: \(filteredRecipes)")
                        self.filteredList.append(contentsOf: filteredRecipes)
                        onCompletion(true)
                        self.filterPage = self.filterPage + 10
                    }
                    break
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    onCompletion(false)
                }
            }
        }
    }
}
