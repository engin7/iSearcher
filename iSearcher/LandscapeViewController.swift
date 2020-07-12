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

    var search: Search!
   
    struct CollectionView {
        struct CellIdentifiers {
          static let searchResultCell = "Landscape"
          static let loadingCell = "LoadingCell"
        }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: CollectionView.CellIdentifiers.searchResultCell, bundle: nil)
          collectionView.register(cellNib, forCellWithReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell)
        
    }
    
    override func viewWillLayoutSubviews() {
         
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
          flowLayout.estimatedItemSize = CGSize(width: (self.collectionView.frame.width-40)/2, height: flowLayout.itemSize.height*1.5)
         }
    }
   
}


extension LandscapeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch search.state {
        case .notSearchedYet, .loading, .noResults:
          return 0
        case .results(let list):
           return list.count
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCellCollection
                cell.itemLabel.text = "Sorry, nothing found"
                cell.artistNameLabel.text = "Empty"
                return cell
                
              case .results(let list):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCellCollection
                let searchResult = list[indexPath.row]
                cell.configure(for: searchResult)
                return cell
  
              }
        }
  
  }

