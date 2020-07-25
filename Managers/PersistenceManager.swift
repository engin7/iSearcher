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
        static let visitedItems = "visitedLinks"
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
                   completed(saveDeletedItems(items: deletedItems))
                   
               case .failure(let error):
                   completed(error)
               }
           }
        
            case .visit:
                retrieveVisitedItems { result in
                    switch result {
                    case .success(var visitedItems):
                        
                       guard !visitedItems.contains(item) else {
                           completed(.alreadyVisited)
                           return
                       }
                       visitedItems.append(item)
                        
                        //  saves the new array with the appended results to UserDefaults for persistance
                        completed(saveVisitedItems(items: visitedItems))
                        
                    case .failure(let error):
                        completed(error)
                    }
            }
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
    
    static func saveDeletedItems(items: [SearchResult]) -> SRError? {
           do {
               let encoder = JSONEncoder()
               let encodedDeletedItems = try encoder.encode(items)
               
               defaults.set(encodedDeletedItems, forKey: Keys.deletedItems)
               return nil
           } catch {
               return .unableToDelete
           }
    }
    
    static func retrieveVisitedItems(completed: @escaping (Result<[SearchResult], SRError>) -> Void) {
           guard let itemsData = defaults.object(forKey: Keys.visitedItems) as? Data else {
                   // if no data found, then need to init w/ empty array
                   completed(.success([]))
                   return
           }
               // need do/try catch for custom object
           do {
               let decoder = JSONDecoder()
               let visitedItems = try decoder.decode([SearchResult].self, from: itemsData)
               completed(.success(visitedItems))
           } catch {
               completed(.failure(.unableToRetrieve))
           }
    }
    
    static func saveVisitedItems(items: [SearchResult]) -> SRError? {
        do {
                let encoder = JSONEncoder()
                let encodedvisitedItems = try encoder.encode(items)
                
                defaults.set(encodedvisitedItems, forKey: Keys.visitedItems)
                return nil
        } catch {
            return .unableToDelete
        }
    }
}


 
