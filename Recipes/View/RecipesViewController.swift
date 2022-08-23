//
//  ReipesViewController.swift
//  Recipes
//
//  Created by noha abbass on 8/23/22.
//

import UIKit

class RecipesViewController: UIViewController {

    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var recipeViewModel = RecipeSearchViewModel()
    private let pageLimit = 10
    var query = ""
    
    enum TableRowType : Int {
        case recipe
        case loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        searchBar.delegate = self
        
    }
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableRowType = TableRowType(rawValue: section) else { return 0 }
        switch tableRowType {
        case .recipe:
            return recipeViewModel.recipesList.count
        case .loader:
            return (recipeViewModel.recipesList.count >= pageLimit && !recipeViewModel.nothingToShow) ? 1 : 0

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        guard let tableRowType = TableRowType(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch tableRowType {
        case .recipe:
            cell.textLabel?.text = recipeViewModel.recipesList[indexPath.row].recipe.label
        case .loader:
            cell.textLabel?.text = "LOADING...."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableRowType = TableRowType(rawValue: indexPath.section) else { return }
        guard !recipeViewModel.recipesList.isEmpty else { return }
        
        if tableRowType == .loader {
            recipeViewModel.getRecipes(query: "chicken") { isSuccess in
                if !isSuccess {
                    self.hideLoader()
                    tableView.reloadData()
                } else {
                    tableView.reloadData()
                }
            }
        }
    }
    
    private func hideLoader(){
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(row: self.recipeViewModel.recipesList.count - 1, section: TableRowType.recipe.rawValue)
            self.recipesTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            self.recipesTableView.cellForRow(at: IndexPath(row: 0, section:  TableRowType.loader.rawValue))?.isHidden = true
        }
    }

}

extension RecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.FILTERS_ARRAY.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterCollectionViewCell
        cell.configure(with: Constants.FILTERS_ARRAY[indexPath.row])
        return cell
    }
}

extension RecipesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        query = searchText
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !query.isEmpty {
            recipeViewModel.recipesList = []
            recipeViewModel.getRecipes(query: query) { (isSuccess) in
                if isSuccess {
                    self.recipesTableView.reloadData()
                } else {
                    print("no suitable data for query")
                }
            }
        }
        query = ""
    }
}
