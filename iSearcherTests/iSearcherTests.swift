//
//  iSearcherTests.swift
//  iSearcherTests
//
//  Created by Engin KUK on 8.07.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//

import XCTest
@testable import iSearcher

class iSearcherTests: XCTestCase {

    var sut:  URLSession! //System Under Test

    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: .default)

    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testValidCallToiTunesGetsHTTPStatusCode200() {

      let url = URL(string: "https://itunes.apple.com/search?term=Tarkan&limit=100")
  
      let promise = expectation(description: "Status code: 200")
 
      let dataTask = sut.dataTask(with: url!) { data, response, error in
 
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {  //valid search code is 200
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
 
      wait(for: [promise], timeout: 5)
    }
    
    
    func testWrongUrl() {

        let url = URL(string: "https://isoundz.apple.com/search?term=Tarkan&limit=100")

       let promise = expectation(description: "Completion handler invoked")
       var statusCode: Int?
       var responseError: Error?
       
        
       let dataTask = sut.dataTask(with: url!) { data, response, error in
         statusCode = (response as? HTTPURLResponse)?.statusCode
         responseError = error
         promise.fulfill()
       }
       dataTask.resume()
        
       wait(for: [promise], timeout: 5)
    
       XCTAssertNotNil(responseError)
       XCTAssertNotEqual(statusCode, 200)
     }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
