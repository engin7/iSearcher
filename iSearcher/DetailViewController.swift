//
//  DetailViewController.swift
//  iSearcher
//
//  Created by Engin KUK on 11.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var searchResult: SearchResult!
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
        deletedSearch.append(searchResult)
        dismiss(animated: true, completion: nil)
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
