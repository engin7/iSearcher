//
//  ViewController.swift
//  iSearcher
//
//  Created by Engin KUK on 8.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate {

 private let search = NetworkManager.shared
 let dataSource = SearchDataSource()

    
 @IBOutlet private weak var collectionView: UICollectionView!
 @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register nib files
        var cellNib = UINib(nibName: SearchDataSource.CollectionView.CellIdentifiers.searchResultCell, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: SearchDataSource.CollectionView.CellIdentifiers.searchResultCell)
              
        cellNib = UINib(nibName: SearchDataSource.CollectionView.CellIdentifiers.loadingCell,
                        bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier:
            SearchDataSource.CollectionView.CellIdentifiers.loadingCell)
       
        collectionView.dataSource = dataSource

     }
   
    override func viewWillAppear(_ animated: Bool){
         collectionView.reloadData()
     }
    
    // MARK:- Navigation
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
              performSegue(withIdentifier: "Detail", sender: indexPath)
             visitedLink(index: indexPath)
             
            }
         
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
 
    extension SearchViewController: CollectionViewDelegate {
    
    func removeCell(indexPath: IndexPath, result: SearchResult) {
      self.collectionView.performBatchUpdates({
        deletedItems.append(result.storeURL)
        self.collectionView.deleteItems(at:[indexPath])
         }, completion:nil)
      }
    }

