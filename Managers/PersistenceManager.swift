//
//  PersistenceManager.swift
//  iSearcher
//
//  Created by Engin KUK on 22.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case visit, delete
}

 
enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard

    enum Keys {
        static let deletedItems = "deletedItems"
        static let urlVisits = "urlVisits"
    }

    static func updateItem(item: SearchResult, actionType: PersistenceActionType, completed: @escaping (SRError?) -> Void) {
        
            switch actionType {
            case .delete:
                retrieveDeletedItems { result in
               switch result {
               case .success(var deletedItems):
                   
                  guard !deletedItems.contains(item) else {
                      completed(.alreadyDeleted)
                      return
                  }
                  deletedItems.append(item)
                   
                   //  saves the new array with the appended results to UserDefaults for persistance
                   completed(save(items: deletedItems))
                   
               case .failure(let error):
                   completed(error)
               }
           }
        
            case .visit:
                return
       }
    }
    
    static func retrieveDeletedItems(completed: @escaping (Result<[SearchResult], SRError>) -> Void) {
        
        guard let itemsData = defaults.object(forKey: Keys.deletedItems) as? Data else {
                // if no data found, then need to init w/ empty array
                completed(.success([]))
                return
            }
            
            // need do/try catch for custom object
            do {
                let decoder = JSONDecoder()
                let deletedItems = try decoder.decode([SearchResult].self, from: itemsData)
 
                completed(.success(deletedItems))
            } catch {
                completed(.failure(.unableToRetrieve))
            }
      
    }
    
    static func save(items: [SearchResult]) -> SRError? {
           do {
               let encoder = JSONEncoder()
               let encodedDeletedItems = try encoder.encode(items)
               
               defaults.set(encodedDeletedItems, forKey: Keys.deletedItems)
               return nil
           } catch {
               return .unableToDelete
           }
       }
    
    
}

 var urlVisits: [String] = []


 
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
   
