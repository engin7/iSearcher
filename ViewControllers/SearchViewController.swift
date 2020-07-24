//
//  ViewController.swift
//  iSearcher
//
//  Created by Engin KUK on 8.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {


    struct CollectionView  {
    struct CellIdentifiers {
      static let searchResultCell = "LandscapeCell"
      static let loadingCell = "LoadingCell"
    }
  }
    
 private let search = NetworkManager.shared
 @IBOutlet private weak var collectionView: UICollectionView!
 @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register nib files
        var cellNib = UINib(nibName: CollectionView.CellIdentifiers.searchResultCell, bundle: nil)
                collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell)
              
        cellNib = UINib(nibName: CollectionView.CellIdentifiers.loadingCell,
                        bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier:
                           CollectionView.CellIdentifiers.loadingCell)
        
     }
   
    
 
   
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "Detail" {
        if case .results(let list) = search.state {
        let nav = segue.destination as! UINavigationController
        let dvc = nav.topViewController as! DetailViewController
        let indexPath = sender as! IndexPath

        let searchResult = filterDeleted(list: list)[indexPath.row]
        dvc.indexPath = indexPath
        dvc.searchResult = searchResult
        dvc.delegateCV = self
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
                self.collectionView.reloadData()
               })
              
              collectionView.reloadData()
              searchBar.resignFirstResponder()
            }
}
 
  
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          
         switch search.state {
          case .notSearchedYet:
            return 0
          case .loading:
            return 1
          case .noResults:
            return 1
          case .results(let list):
             return filterDeleted(list: list).count
          }
    
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
              
              switch search.state {
                    case .notSearchedYet:
                      fatalError("Not possible")
                      
                    case .loading:
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                          CollectionView.CellIdentifiers.loadingCell, for: indexPath)
                      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
                      spinner.startAnimating()
                      return cell
                      
                    case .noResults:
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell, for: indexPath) as! LandscapeCell
                      cell.itemLabel.text = "Sorry, nothing found"
                      cell.artistNameLabel.text = "Empty"
                      return cell
                      
                    case .results(let list):
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell, for: indexPath) as! LandscapeCell
                       let searchResult = filterDeleted(list: list)[indexPath.row]
                       cell.configure(for: searchResult)
                       return cell
        
                    }
              }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             performSegue(withIdentifier: "Detail", sender: indexPath)
            visitedLink(index: indexPath)
            //reload
           }
        }
  
    extension SearchViewController: CollectionViewDelegate {
    
    func removeCell(indexPath: IndexPath, result: SearchResult){
      self.collectionView.performBatchUpdates({
        deletedItems.append(result.storeURL)
        self.collectionView.deleteItems(at:[indexPath])
         }, completion:nil)
      }
     
    }

