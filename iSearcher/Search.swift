//
//  Search.swift
//  iSearcher
//
//  Created by Engin KUK on 12.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

 
import Foundation
import UIKit


class Search {
  
    enum State {
      case notSearchedYet
      case loading
      case noResults
      case results([SearchResult])
    }
    
    typealias SearchComplete = (Bool) -> Void
    // special closure takes Bool as parameter returns -> () no value to make code more readable

    
  private(set) var state: State = .notSearchedYet
  private var dataTask: URLSessionDataTask? = nil
    
    func performSearch(for text: String, completion: @escaping SearchComplete ) {
        
        if !text.isEmpty {
           dataTask?.cancel()  // new search cancels old one
           state = .loading
             let url = iTunesURL(searchText: text)
             let session = URLSession.shared
             dataTask = session.dataTask(with: url, completionHandler: {data, response, error in
               var newState = State.notSearchedYet
               var success = false
               // if the search cancelled ignore error code and return
               if let error = error as NSError?, error.code == -999 {
                 return
               }
               
               if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                let searchResults = self.parse(data: data)
                if  searchResults.isEmpty {
                   newState = .noResults
                 } else {
                    newState = .results(searchResults)
                    
                 }
                 success = true
               }
               DispatchQueue.main.async {
                 self.state = newState
                 completion(success)
                }
             })
             dataTask?.resume()
           }
    }
     
    func visitedLink(index: IndexPath) {
        
         let row = index[1]
         let url:String
        
           switch state {
           case .notSearchedYet, .loading, .noResults:
             return
           case .results(let list):
             url = list[row].storeURL
           }
         // check if exists
        visitedLinks.append(url)
     }
    
    
    // MARK:- Private Methods

    private func iTunesURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(
          withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format:
            "https://itunes.apple.com/search?term=%@&limit=100", encodedText)
        let url = URL(string: urlString)
        return url!
      }
       
      private func parse(data: Data) -> [SearchResult] {
        do {
          let decoder = JSONDecoder()
          let result = try decoder.decode(ResultArray.self, from:data)
           return result.results
        } catch {
          print("JSON Error: \(error)")
      return [] }
      }
      
      
    
   }

 
 
