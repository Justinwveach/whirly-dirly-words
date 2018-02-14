//
//  SearchTest.swift
//  WhirlyDirlyWordsTests
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import XCTest
@testable import WhirlyDirlyWords

class SearchTests: XCTestCase {
    
    var words: Words!
    var allWords: Array<String>!
    let searchWord = "zebra"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        allWords = Parser.parseWords(file: "words-extended", type: "txt")
        Words.sharedInstance.populate(allWords: allWords)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBinarySearch() {
        // This is an example of a performance test case.
        let start = Date()
        self.measure {
            let found = Words.sharedInstance.validate(word: searchWord)
            assert(found == true)
        }
        let end = Date()
        print("Binary Search took \(end.timeIntervalSince(start))")
    }
    
    func testLinearSearch() {
        let start = Date()

        self.measure {
            var found = false
            for word in allWords {
                if searchWord == word {
                    found = true
                    break;
                }
            }
            
            assert(found == true)
        }
        let end = Date()
        print("Linear Search took \(end.timeIntervalSince(start))")
    }
    
}
