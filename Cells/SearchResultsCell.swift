//
//  SearchResultCellCollection.swift
//  iSearcher
//
//  Created by Engin KUK on 12.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

 
import UIKit

class SearchResultsCell: UICollectionViewCell {
    
  
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    private var downloadTask: URLSessionDownloadTask?
    private var visited: [SearchResult] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.isUserInteractionEnabled = true
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
        if let imageURL = URL(string: result.imageL) {
        downloadTask = NetworkManager.shared.loadImage(imageView: artworkImageView, url: imageURL)
        }
         
        PersistenceManager.retrieveVisitedItems {
             [weak self] result in
             guard self != nil else { return }
             switch result {
              case .success(let visitedItems):
              self!.visited = visitedItems
              case .failure:
              return
             }
        }
        
        if visited.contains(result) {
                       itemLabel.textColor = .lightGray
                       artistNameLabel.textColor = .lightGray
                       artworkImageView.alpha = 0.4
        } else {
                       itemLabel.textColor = .black
                       artistNameLabel.textColor = .darkGray
                       artworkImageView.alpha = 1
        }
                 
    }
}
