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
    
    func testPuzzleValidation() {
        let wordsArray = Parser.parseWords(file: "words-all", type: "txt")
        Words.sharedInstance.populate(allWords: wordsArray)
        
        let puzzle = CrosswordPuzzle(size: 8)
        let tile1 = Tile(letter: "t", column: 0, row: 0)
        let tile2 = Tile(letter: "e", column: 0, row: 1)
        let tile3 = Tile(letter: "s", column: 0, row: 2)
        let tile4 = Tile(letter: "t", column: 0, row: 3)
        
        let tile5 = Tile(letter: "a", column: 1, row: 1)
        let tile6 = Tile(letter: "t", column: 2, row: 1)
        
        puzzle.add(tile1)
        puzzle.add(tile2)
        puzzle.add(tile3)
        puzzle.add(tile4)
        puzzle.add(tile5)
        puzzle.add(tile6)
        
        puzzle.push("test")
        puzzle.push("eat")
        
        assert(puzzle.validateBoard() == true)
    }
    
    func testPerformanceExample() {
        let wordsArray = Parser.parseWords(file: "words-all", type: "txt")
        Words.sharedInstance.populate(allWords: wordsArray)

        for _ in 0..<10 {
            let crosswordGenerator = CrosswordGenerator(words: Words.sharedInstance)
            
            let puzzle = crosswordGenerator.createPuzzle(wordStructure: [.medium, .short, .short, .medium], size: 8)

            for row in 0..<8 {
                var rowString = ""
                for column in 0..<8 {
                    let tile = puzzle.getTile(column: column, row: row)
                    rowString.append(tile.isEmpty ? "-" : tile.letter)
                }
            print("\(rowString) \n")
        }
            print("\n\n")
        }
    }
        
}
