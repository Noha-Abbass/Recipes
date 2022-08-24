//
//  LoadingTableViewCell.swift
//  Recipes
//
//  Created by noha abbass on 8/24/22.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        activityIndicator.startAnimating()
    }
    
}
