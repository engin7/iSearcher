//
//  DetailViewController.swift
//  iSearcher
//
//  Created by Engin KUK on 11.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit
 

protocol DeleteRowInTableviewDelegate: class {
   
    func removeCell(indexPath: IndexPath,  result: SearchResult)

}

protocol CollectionViewDelegate: class {
   
    func removeCell(indexPath: IndexPath)

}
 
class DetailViewController: UIViewController {
    
    weak var delegateRow: DeleteRowInTableviewDelegate?
    weak var delegateCV: CollectionViewDelegate?

    var searchResult: SearchResult!
    var indexPath:IndexPath?
    var downloadTask: URLSessionDownloadTask?

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artworkImageView.layer.cornerRadius = 20
        
        if searchResult != nil {
        updateUI()
        }
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
       downloadTask?.cancel()
    }
    
     // MARK:- Actions

     @IBAction func backButtonPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
         
     }
      
     @IBAction func deleteItem(_ sender: Any) {
        
        let message =  "Are you sure to delete this item?"
        let alert = UIAlertController(title: "Deleting item", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
          
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
 
                self.delegateRow?.removeCell(indexPath: self.indexPath!, result: self.searchResult)
                self.delegateCV?.removeCell(indexPath: self.indexPath!)
                  }
            self.dismiss(animated: true, completion: nil)
        }))
        
       self.present(alert, animated: true)
     }
  
    // MARK:- Helper Methods

    func updateUI() {
      nameLabel.text = searchResult.itemName
      
      if searchResult.artist.isEmpty {
        artistNameLabel.text = "Unknown"
      } else {
        artistNameLabel.text = searchResult.artist
      }
      
      kindLabel.text = searchResult.type
      genreLabel.text = searchResult.genre
      // Show price
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      formatter.currencyCode = searchResult.currency
      
      let priceText: String
      if searchResult.price == 0 {
        priceText = "Free"
      } else if let text = formatter.string(
        from: searchResult.price as NSNumber) {
        priceText = text
      } else {
        priceText = ""
      }
      priceLabel.text = priceText
      // Get image
      if let imageURL = URL(string: searchResult.imageL) {
        downloadTask = artworkImageView.loadImage(url: imageURL)
      }
    }
    
    
}
