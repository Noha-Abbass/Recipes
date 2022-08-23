//
//  FilterCollectionViewCell.swift
//  Recipes
//
//  Created by noha abbass on 8/23/22.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filterNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with filterName: String) {
        filterNameLbl.text = filterName
    }
}
