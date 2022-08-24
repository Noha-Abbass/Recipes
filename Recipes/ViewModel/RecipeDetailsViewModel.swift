//
//  RecipeDetailsViewModel.swift
//  Recipes
//
//  Created by noha abbass on 8/24/22.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class RecipeDetailsViewModel {
    var imageUrl = ""
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    func getRecipeImage(onCompletion: @escaping (UIImage)-> ()) {
        guard let url = URL(string: imageUrl) else { return }
        AF.request(url).responseImage{ response in
            if case .success(let image) = response.result {
                onCompletion(image)
            }
        }
    }
}
