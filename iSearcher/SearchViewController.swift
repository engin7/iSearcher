//
//  ViewController.swift
//  iSearcher
//
//  Created by Engin KUK on 8.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  // use constant cell identifier so you change it only at one place in the future
    struct TableView {
      struct CellIdentifiers {
        static let searchResultCell = "SearchResultCell"
      }
    }
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         let cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                                    TableView.CellIdentifiers.searchResultCell)
        searchBar.becomeFirstResponder()
    }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchResults = []
    if searchBar.text! != "Boom" {
    for i in 0...99 {
      let searchResult = SearchResult()
      searchResult.itemName = String(format: "Mock Result %d ", i)
      searchResult.artistName = searchBar.text!
      searchResults.append(searchResult)
    }
   }
    hasSearched = true
    tableView.reloadData()
    }
    
 func position(for bar: UIBarPositioning) -> UIBarPosition {
  return .topAttached
  }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if !hasSearched {
            return 0
          } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
          }
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      

     let cell = tableView.dequeueReusableCell(
                   withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
   
    if searchResults.count == 0 {
      cell.itemLabel.text = "Sorry, nothing found"
      cell.artistNameLabel.text = "Empty"
    } else {
      let searchResult = searchResults[indexPath.row]
      cell.itemLabel.text = searchResult.itemName
      cell.artistNameLabel.text = searchResult.artistName
    }
      return cell
  }
    
    func tableView(_ tableView: UITableView,
         didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
         willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      if searchResults.count == 0 {
        return nil
    } else {
        return indexPath
      }
    }
    
}

