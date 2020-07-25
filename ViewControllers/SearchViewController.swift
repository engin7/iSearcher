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
 private let dataSource = SearchDataSource()

    
 @IBOutlet private weak var collectionView: UICollectionView!
 @IBOutlet private weak var searchBar: UISearchBar!
    
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
          if case .results(let list) = search.state {
          let searchResult = dataSource.getFilteredData(list: list)[indexPath.row]
          if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
         {
         vc.indexPath = indexPath
         vc.searchResult = searchResult
         vc.delegateCV = self
         let navigationController = UINavigationController(rootViewController: vc)
         navigationController.modalPresentationStyle = .fullScreen
         present(navigationController, animated: true, completion: nil)
         }
         PersistenceManager.updateItem(item: searchResult, actionType: .visit) { [weak self] error in
            guard self != nil else { return }
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
        PersistenceManager.updateItem(item: result, actionType: .delete) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                let message =  "item deleted successfully!"
                      let alert = UIAlertController(title: "item deleted", message: message, preferredStyle: .alert)
                     
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
                          self.dismiss(animated: true, completion: nil)
                      }))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.present(alert, animated: true)
                      }
                return
            }
                let message =  error.rawValue
                      let alert = UIAlertController(title: "error", message: message, preferredStyle: .alert)
                     
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
                          self.dismiss(animated: true, completion: nil)
                      }))
                     self.present(alert, animated: true)
        }
        
        self.collectionView.deleteItems(at:[indexPath])
         }, completion:nil)
      }
    }

