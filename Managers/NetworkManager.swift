//
//  Search.swift
//  iSearcher
//
//  Created by Engin KUK on 12.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

 
import UIKit


class NetworkManager {
static let shared = NetworkManager() // singleton
private let baseURL = "https://itunes.apple.com/search?term=%@&limit=100"
var state: State = .notSearchedYet
private var dataTask: URLSessionDataTask? = nil

private init() {}
 
    enum State {
      case notSearchedYet
      case loading
      case noResults
      case results([SearchResult])
    }
    
typealias SearchComplete = (Bool) -> Void
// special closure takes Bool as parameter returns -> () no value to make code more readable

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
                      
                let filteredResults = filterDeleted(list: searchResults)
                    
                    newState = .results(filteredResults)
                      
                   }
                   success = true
                 }
                 DispatchQueue.main.async {
                   self.state = newState
                   completion(success) //Bool
                  }
               })
               dataTask?.resume()
             }
      }
    
    // MARK:- Private Methods

      private func iTunesURL(searchText: String) -> URL {
          let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
          let endPoint = String(format: baseURL, encodedText) //term=%@ adds text to %@
          let url = URL(string: endPoint)
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

 
 
 
