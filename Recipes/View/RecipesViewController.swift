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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var recipeViewModel = RecipeSearchViewModel()
    private let pageLimit = 10
    var query = ""
    var isFilter = false
    var selectedFilter = ""
    var currentSelected = 0
    
    enum TableRowType : Int {
        case recipe
        case loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        recipesTableView.isHidden = true
        filtersCollectionView.isHidden = true
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
            return isFilter ? recipeViewModel.filteredList.count : recipeViewModel.recipesList.count
        case .loader:
            return (recipeViewModel.recipesList.count % pageLimit == 0 && !recipeViewModel.nothingToShow) ? 1 : 0

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        guard let tableRowType = TableRowType(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch tableRowType {
        case .recipe:
            cell.textLabel?.text = isFilter ? recipeViewModel.filteredList[indexPath.row].recipe.label : recipeViewModel.recipesList[indexPath.row].recipe.label
        case .loader:
            cell.textLabel?.text = "LOADING...."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableRowType = TableRowType(rawValue: indexPath.section) else { return }
        if isFilter {
            guard !recipeViewModel.filteredList.isEmpty else { return }
        } else {
            guard !recipeViewModel.recipesList.isEmpty else { return }
        }
        
        if tableRowType == .loader {
            if isFilter {
                recipeViewModel.getFilteredRecipes(query: query, filter: selectedFilter){ isSuccess in
                    if !isSuccess {
                        self.hideLoader()
                        tableView.reloadData()
                    } else {
                        tableView.reloadData()
                    }
                }
            } else {
                recipeViewModel.getRecipes(query: query) { isSuccess in
                    if !isSuccess {
                        self.hideLoader()
                        tableView.reloadData()
                    } else {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func hideLoader(){
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(row: self.isFilter ? self.recipeViewModel.filteredList.count - 1 : self.recipeViewModel.recipesList.count - 1, section: TableRowType.recipe.rawValue)
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
        cell.backgroundColor = currentSelected == indexPath.row ? .purple : .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !query.isEmpty {
            currentSelected = indexPath.row
            recipeViewModel.filterPage = 0
            recipeViewModel.filterNothingToShow = false
            recipeViewModel.filteredList = []
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            messageLabel.isHidden = true
            self.filtersCollectionView.reloadData()
            
            if indexPath.row == 0 {
                self.isFilter = false
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.messageLabel.isHidden = true
                self.recipesTableView.isHidden = false
                self.recipesTableView.scrollToRow(at: IndexPath(row: NSNotFound, section: 0), at: .top, animated: true)
                self.recipesTableView.reloadData()
            } else {
                selectedFilter = Constants.FILTERS_ARRAY[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "-")
                recipeViewModel.getFilteredRecipes(query: query, filter: self.selectedFilter) { (isSuccess) in
                    if isSuccess {
                        self.isFilter = true
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.messageLabel.isHidden = true
                        self.recipesTableView.isHidden = false
                        self.recipesTableView.reloadData()
                        self.recipesTableView.scrollToRow(at: IndexPath(row: NSNotFound, section: 0), at: .top, animated: true)
                    } else {
                        self.recipeViewModel.filteredList = []
                        self.recipeViewModel.filterPage = 0
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.messageLabel.isHidden = false
                        self.recipesTableView.isHidden = true
                        self.messageLabel.text = "No recipes found in \"\(Constants.FILTERS_ARRAY[indexPath.row])\""
                    }
                }
            }

        }
    }
}

extension RecipesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        query = searchText
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !query.isEmpty {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            messageLabel.isHidden = true
            filtersCollectionView.isHidden = false
            recipeViewModel.recipesList = []
            recipeViewModel.nothingToShow = false
            recipeViewModel.page = 0
            recipeViewModel.filterNothingToShow = false
            recipeViewModel.filterPage = 0
            recipesTableView.isHidden = true
            recipeViewModel.getRecipes(query: query) { (isSuccess) in
                if isSuccess {
                    self.recipesTableView.isHidden = false
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.messageLabel.isHidden = true
                    self.recipesTableView.reloadData()
                } else {
                    self.filtersCollectionView.isHidden = true
                    self.recipesTableView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.messageLabel.isHidden = false
                    self.messageLabel.text = "No recipes found"
                    print("no suitable data for query")
                }
            }
        } else {
            filtersCollectionView.isHidden = true
            recipesTableView.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = "Search for recipes"
        }
    }
}
