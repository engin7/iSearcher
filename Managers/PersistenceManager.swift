//
//  PersistenceManager.swift
//  iSearcher
//
//  Created by Engin KUK on 22.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import Foundation

var deletedItems : [String] = []
var urlVisits: [String] = []


func filterDeleted(list: [SearchResult]) -> [SearchResult]  {
      let persistDeleted =  UserDefaults.standard.object(forKey: "deletedItems") as! [String]?
     
    
          if persistDeleted != nil {
              deletedItems.append(contentsOf: persistDeleted!)
          }
          // remove duplicates
         let unique = Array(Set(deletedItems))
          UserDefaults.standard.set(unique, forKey: "deletedItems")
         // filter the list not to show deleted items
          return list.filter({!unique.contains($0.storeURL)})
  }

   func visitedLink(index: IndexPath) {
       
        let row = index[1]
        let url:String
       
    switch NetworkManager.shared.state {
          case .notSearchedYet, .loading, .noResults:
            return
          case .results(let list):
            url = list[row].storeURL
          }

          urlVisits.append(url)
          
         let dummy =  UserDefaults.standard.object(forKey: "visitedLinks") as! [String]?
        
       if dummy != nil {
           urlVisits.append(contentsOf: dummy!)
       }
         // remove duplicates
        let unique = Array(Set(urlVisits))
         UserDefaults.standard.set(unique, forKey: "visitedLinks")
       }
   
