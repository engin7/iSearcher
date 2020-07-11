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
        static let loadingCell = "LoadingCell"
      }
    }
    
    var dataTask: URLSessionDataTask?
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register nib files
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                                    TableView.CellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell,
                        bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
                           TableView.CellIdentifiers.loadingCell)
        
        searchBar.becomeFirstResponder()
    }
    
    // MARK:- Helper Methods
    
    func iTunesURL(searchText: String) -> URL {
      let encodedText = searchText.addingPercentEncoding(
        withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      let urlString = String(format:
          "https://itunes.apple.com/search?term=%@&limit=100", encodedText)
      let url = URL(string: urlString)
      return url!
    }
     
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
        dataTask?.cancel()  // new search cancels old one
        isLoading = true
        tableView.reloadData()
        hasSearched = true
        searchResults = []
        // created url object
      let url = iTunesURL(searchText: searchBar.text!)
        let session = URLSession.shared
           dataTask = session.dataTask(with: url,
              completionHandler: { data, response, error in
                // -999 is search cancelled error code we can ignore
             if let error = error as NSError?, error.code == -999 {
                 return
              } else if let httpResponse = response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 {
                if let data = data {
                self.searchResults = self.parse(data: data)
                  DispatchQueue.main.async {
                    self.isLoading = false
                    self.tableView.reloadData()
              }
                return
                }
              } else {
                print("Failure! \(response!)")
              }
                DispatchQueue.main.async {
                  self.hasSearched = false
                  self.isLoading = false
                  self.tableView.reloadData()
                  self.showNetworkError()
                }
        })
            // start dataTask
            dataTask?.resume()
        }
      }
    
 func position(for bar: UIBarPositioning) -> UIBarPosition {
  return .topAttached
  }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if isLoading {
             return 1
          } else if !hasSearched {
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
    if isLoading {
      let cell = tableView.dequeueReusableCell(withIdentifier:
          TableView.CellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if searchResults.count == 0 {
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
      if searchResults.count == 0 || isLoading  {
        return nil
    } else {
        return indexPath
      }
    }
    
}

