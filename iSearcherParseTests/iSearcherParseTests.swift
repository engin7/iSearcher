//
//  iSearcherParseTests.swift
//  iSearcherParseTests
//
//  Created by Engin KUK on 16.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import XCTest
@testable import iSearcher


class iSearcherParseTests: XCTestCase {

    var sut : NetworkManager! //System Under Test
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExample() {
       
        let expectedCount = 100
        let promise = expectation(description: "Status code: 200")
 // assuming user hasn't deleted any items, very famous singer Adale should fill list of 100 items
        sut.performSearch(for: "Adale", completion: {success in
              if success {
                
                switch self.sut.state {
            case .notSearchedYet, .loading, .noResults:
              return
            case .results(let list):
               
            let extractedCount  = list.count
            XCTAssertEqual(extractedCount, expectedCount, "Failed to get number of expected search results")
           }
                promise.fulfill()

               }
           })
         wait(for: [promise], timeout: 5)
 
    }

    
    func testDeleted() {
          
           let expectedCount = 95
           let promise = expectation(description: "Status code: 200")
        
        
           sut.performSearch(for: "Swift", completion: {success in
                 if success {
                   
                   switch self.sut.state {
               case .notSearchedYet, .loading, .noResults:
                 return
               case .results(let list):
                  
                deletedItems  = list.prefix(5).map{ $0.storeURL }
//                self.sut.filterDeleted()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    let extractedCount = list.count
                    XCTAssertEqual(extractedCount, expectedCount, "Failed to get number of expected search results after deleting 5 items")
                      }
                
                deletedItems = []
                UserDefaults.standard.set(deletedItems, forKey: "deletedItems")
                // be aware line above will remove all persistent deleted items
              }
                    promise.fulfill()

                  }
              })
        
             
            wait(for: [promise], timeout: 5)
    
       }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            
            sut.performSearch(for: "Adale", completion: {success in  })
       
        }
    }

}
