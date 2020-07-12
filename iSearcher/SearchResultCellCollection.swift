//
//  SearchResultCellCollection.swift
//  iSearcher
//
//  Created by Engin KUK on 12.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

 
import UIKit

class SearchResultCellCollection: UICollectionViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
         downloadTask?.cancel()
         downloadTask = nil
       }
      
    
     // MARK:- Public Methods
    func configure(for result: SearchResult) {
        itemLabel.text = result.itemName
        if result.artist.isEmpty {
          artistNameLabel.text = "Unknown"
        } else {
          artistNameLabel.text = String(format: "%@ (%@)",
                            result.artist, result.type)
        }
        
        artworkImageView.image = UIImage(named: "Placeholder")
        if let imageURL = URL(string: result.image) {
          downloadTask = artworkImageView.loadImage(url: imageURL)
        }
        
    }
   
}
