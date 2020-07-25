//
//  SearchDataSource.swift
//  iSearcher
//
//  Created by Engin KUK on 25.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

class SearchDataSource: NSObject, UICollectionViewDataSource {
     
 
      struct CollectionView  {
      struct CellIdentifiers {
        static let searchResultCell = "SearchResultsCell"
        static let loadingCell = "LoadingCell"
      }
    }
     
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          
         switch NetworkManager.shared.state {
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
              
              switch NetworkManager.shared.state {
                    case .notSearchedYet:
                      fatalError("Not possible")
                      
                    case .loading:
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                          CollectionView.CellIdentifiers.loadingCell, for: indexPath)
                      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
                      spinner.startAnimating()
                      return cell
                      
                    case .noResults:
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultsCell
                      cell.itemLabel.text = "Sorry, nothing found"
                      cell.artistNameLabel.text = "Empty"
                      return cell
                      
                    case .results(let list):
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultsCell
                       let searchResult = filterDeleted(list: list)[indexPath.row]
                       cell.configure(for: searchResult)
                       return cell
        
                    }
              }
    
      
}
