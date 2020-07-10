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
    
    // MARK:- Helper Methods
    
    func iTunesURL(searchText: String) -> URL {
      let encodedText = searchText.addingPercentEncoding(
        withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      let urlString = String(format:
          "https://itunes.apple.com/search?term=%@", encodedText)
      let url = URL(string: urlString)
      return url!
    }
    
    func performStoreRequest(with url: URL) -> Data? {
      do {
        return try Data(contentsOf:url)
      } catch {
       print("Download Error: \(error.localizedDescription)")
         if let jsonString = performStoreRequest(with: url) {
          print("Received JSON string '\(jsonString)'")
        }
        showNetworkError()
    return nil
    } }
    
    func parse(data: Data) -> [SearchResult] {
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(ResultArray.self, from:data)
        return result.results
      } catch {
        print("JSON Error: \(error)")
    return [] }
    }
    
    func showNetworkError() {
      let alert = UIAlertController(title: "Sorry",
        message: "error accessing the iTunes Store." +
        " Try again.", preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default,
                             handler: nil)
    present(alert, animated: true, completion: nil)
      alert.addAction(action)
    }
    
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      if !searchBar.text!.isEmpty {
        searchBar.resignFirstResponder()
        hasSearched = true
        searchResults = []
        let url = iTunesURL(searchText: searchBar.text!)
        print("URL: '\(url)'")
        if let data = performStoreRequest(with: url) {
        searchResults = parse(data: data)
        }
        tableView.reloadData()
      }
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
      if searchResult.artist.isEmpty {
        cell.artistNameLabel.text = "Unknown"
      } else {
        cell.artistNameLabel.text = String(format: "%@ (%@)",
      searchResult.artist, searchResult.type)
     }
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

