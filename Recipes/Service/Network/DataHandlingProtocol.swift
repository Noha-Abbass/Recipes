//
//  DataHandlingProtocol.swift
//  Recipes
//
//  Created by noha abbass on 8/23/22.
//

import Foundation

protocol DataHandlingProtocol {
    func getAllRecipes(urlString: String, query: String, page: Int, completion: @escaping (Result<[Recipe], Error>) -> ())
}
