//
//  LandscapeViewController.swift
//  iSearcher
//
//  Created by Engin KUK on 12.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

 @IBOutlet private weak var collectionView: UICollectionView!

    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?

    struct CollectionView {
        struct CellIdentifiers {
          static let searchResultCell = "SearchResultCellCollection"
          static let loadingCell = "LoadingCell"
        }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: CollectionView.CellIdentifiers.searchResultCell, bundle: nil)
          collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell)
      
 
          if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = CGSize(width: flowLayout.itemSize.width, height: flowLayout.itemSize.height*2)
          }
        
    }
     
}


extension LandscapeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if isLoading {
//             return 1
//          } else if !hasSearched {
//            return 0
//          } else if searchResults.count == 0 {
//            return 1
//        } else {
            return searchResults.count
//          }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
              CollectionView.CellIdentifiers.loadingCell, for: indexPath)
          let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
          spinner.startAnimating()
          return cell
        } else if searchResults.count == 0 {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCellCollection
          cell.itemLabel.text = "Sorry, nothing found"
          cell.artistNameLabel.text = "Empty"
          return cell
        } else {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCellCollection
          let searchResult = searchResults[indexPath.row]
          cell.configure(for: searchResult)
          return cell
        }
    }
     
   
}

