//
//  CrosswordGeneratorTest.swift
//  WhirlyDirlyWordsTests
//
//  Created by Justin Veach on 1/19/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import XCTest
@testable import WhirlyDirlyWords

class CrosswordGeneratorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        let wordsArray = Parser.parseWords(file: "words-all", type: "txt")
        Words.sharedInstance.populate(allWords: wordsArray)

        for i in 0..<10 {
            let crosswordGenerator = CrosswordGenerator(words: Words.sharedInstance, size: 8)
            
            crosswordGenerator.createPuzzle(wordStructure: [.medium, .short, .short, .medium])

            for row in 0..<8 {
                var rowString = ""
                for column in 0..<8 {
                    let tile = crosswordGenerator.getTile(column: column, row: row)
                    rowString.append(tile.isEmpty ? "-" : tile.letter)
                }
            print("\(rowString) \n")
        }
            print("\n\n")
        }
    }
        
}
