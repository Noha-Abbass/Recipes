//
//  DetailsViewController.swift
//  Recipes
//
//  Created by noha abbass on 8/24/22.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var detailsViewModel: RecipeDetailsViewModel?
    var recipeNameStr: String = ""
    var imageURL: String = ""
    var websiteUrl: String = ""
    var shareUrl: String = ""
    var ingredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        detailsViewModel = RecipeDetailsViewModel(imageUrl: imageURL)
        detailsViewModel?.getRecipeImage { (image) in
            self.recipeImage.image = image
        }
        recipeName.text = recipeNameStr
    }
    
    @IBAction func onShareClicked(_ sender: Any) {
        if let url = URL(string: shareUrl){
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onRecipeWebsiteClicked(_ sender: Any) {
        if let url = URL(string: websiteUrl){
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = "\u{2022} \(ingredients[indexPath.row].trimmingCharacters(in: CharacterSet(charactersIn: "\"")))"
        return cell
    }
    
    
}
