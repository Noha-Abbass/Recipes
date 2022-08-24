//
//  RecipeTableViewCell.swift
//  Recipes
//
//  Created by noha abbass on 8/23/22.
//

import UIKit
import Alamofire
import AlamofireImage

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var healthLabels: UILabel!
    
    var imageUrl: String = ""
    var recipeNameStr: String?
    var sourceStr: String?
    var healthLabelsStr: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        healthLabels.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(){
        AF.request(imageUrl).responseImage{ response in
            if case .success(let resultImage) = response.result {
                self.recipeImage.image = resultImage
            }
        }
        recipeName.text = recipeNameStr
        source.text = sourceStr
        healthLabels.text = healthLabelsStr
    }
    
}
