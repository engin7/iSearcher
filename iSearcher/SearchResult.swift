//
//  SearchResult.swift
//  iSearcher
//
//  Created by Engin KUK on 9.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import Foundation
 

class ResultArray: Codable {
     
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult:Codable, CustomStringConvertible {
 
    var description: String {
      return "Kind: \(kind ?? "None"), Name: \(itemName), Artist Name: \(artistName ?? "None")\n"
    }
    
    var artistName: String? = ""
    var trackName: String? = ""
    var itemName:String {
    return trackName ?? collectionName ?? ""
  }
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    var image = ""
    var imageL = ""
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    
    var storeURL: String {
      return trackViewUrl ?? collectionViewUrl ?? ""
    }
    var price: Double {
      return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    var genre: String {
      if let genre = itemGenre {
        return genre
      } else if let genres = bookGenre {
        return genres.joined(separator: ", ")
      }
    return "" }
    // instead of putting service data directly, modify it so its more readable & human-friendly
   var type:String {
      let kind = self.kind ?? "audiobook"
      switch kind {
      case "album": return "Album"
      case "audiobook": return "Audio Book"
      case "book": return "Book"
      case "ebook": return "E-Book"
      case "feature-movie": return "Movie"
      case "music-video": return "Music Video"
      case "podcast": return "Podcast"
      case "software": return "App"
      case "song": return "Song"
      case "tv-episode": return "TV Episode"
      default: break
      }
      return "Unknown"
    }
    
    var artist: String {
        return artistName ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
      case image = "artworkUrl60"
      case imageL = "artworkUrl100"
      case itemGenre = "primaryGenreName"
      case bookGenre = "genres"
      case itemPrice = "price"
      case kind, artistName, currency
      case trackName, trackPrice, trackViewUrl
      case collectionName, collectionViewUrl, collectionPrice
    }
    
}
