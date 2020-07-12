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
    
    var landscapeVC: LandscapeViewController?
    private let search = Search()
    
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
        
     }
    
    override func willTransition(
        to newCollection: UITraitCollection,
        with coordinator: UIViewControllerTransitionCoordinator) {
      super.willTransition(to: newCollection, with: coordinator)
      switch newCollection.verticalSizeClass {
      case .compact:
        showLandscape(with: coordinator)
      case .regular, .unspecified:
        hideLandscape(with: coordinator)
      @unknown default:
        fatalError()
      }
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "Detail" {
        if case .results(let list) = search.state {
        let nav = segue.destination as! UINavigationController
        let dvc = nav.topViewController as! DetailViewController
        let indexPath = sender as! IndexPath
        let searchResult = list[indexPath.row]
        dvc.searchResult = searchResult
        }
      }
    }
    
    // MARK:- Helper Methods
    
    func showNetworkError() {
      let alert = UIAlertController(title: "Sorry...", message: "Error occured connecting the iTunes Store. Please try again.", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
    
    func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
      guard landscapeVC == nil else { return }
       if self.presentedViewController != nil {  // hide detail screen
        self.dismiss(animated: true, completion: nil)
      }
      landscapeVC = storyboard!.instantiateViewController(
                    withIdentifier: "LandscapeViewController")
                    as? LandscapeViewController
      if let controller = landscapeVC {
      controller.search = search  // pass in results array
      self.searchBar.resignFirstResponder()   // hide keyboard
        controller.view.frame = view.bounds   // full screen
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
    } }
    
     func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeVC {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            landscapeVC = nil
        }
    }
        
}

extension SearchViewController: UISearchBarDelegate {
      
    func position(for bar: UIBarPositioning) -> UIBarPosition {
     return .topAttached
     }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        search.performSearch(for: searchBar.text!, completion: {success in
            
       if !success {
                  self.showNetworkError()
                }
                self.tableView.reloadData()
               })
              
              tableView.reloadData()
              searchBar.resignFirstResponder()
            }
  
}
 
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          switch search.state {
          case .notSearchedYet:
            return 0
          case .loading:
            return 1
          case .noResults:
            return 1
          case .results(let list):
            return list.count
          }
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          switch search.state {
          case .notSearchedYet:
            fatalError("Not possible")
            
          case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
            
          case .noResults:
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath)
            
          case .results(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            
            let searchResult = list[indexPath.row]
            cell.configure(for: searchResult)
            return cell
          }
        }
    
    func tableView(_ tableView: UITableView,
         didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         performSegue(withIdentifier: "Detail", sender: indexPath)
        
    }
    
     func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
       switch search.state {
       case .notSearchedYet, .loading, .noResults:
         return nil
       case .results:
         return indexPath
       }
     }
    
}

