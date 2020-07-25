//
//  SRError.swift
//  iSearcher
//
//  Created by Engin KUK on 25.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import Foundation

enum SRError: String, Error {
    
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data recieved from the server was invalid. Please try again"
    case unableToDelete = "There was an error deleting this item. Please try again."
    case unableToVisit = "There was an error visiting this item. Please try again."
    case unableToRetrieve = "There was an error retrieving this item. Please try again."
    case alreadyDeleted = "You've already deleted this item."
    case alreadyVisited = "You've already visited this user."

}
