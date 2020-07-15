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

    var sut:  Search! //System Under Test
    
    override func setUp() {
        super.setUp()
        sut = Search()
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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
