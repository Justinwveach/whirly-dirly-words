//
//  CrosswordGeneratorTest.swift
//  WhirlyDirlyWordsTests
//
//  Created by Justin Veach on 1/19/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import XCTest
@testable import WhirlyDirlyWords

class CrosswordGeneratorTests: XCTestCase {
    
    var wordsArray: Array<String> = [String]()
    var crosswordGenerator: CrosswordGenerator!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        wordsArray = Parser.parseWords(file: "words-all", type: "txt")
        Words.sharedInstance.populate(allWords: wordsArray)
        crosswordGenerator = CrosswordGenerator(words: Words.sharedInstance)
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
        for _ in 0..<10 {
            let puzzle = crosswordGenerator.createPuzzle(wordStructure: [.medium, .short, .short, .medium], size: 8)

            for row in 0..<8 {
                var rowString = ""
                for column in 0..<8 {
                    let tile = puzzle.getTile(column: column, row: row)
                    rowString.append(tile.isEmpty ? "-" : tile.character)
                }
            print("\(rowString) \n")
        }
            print("\n\n")
        }
    }
    
    
    /// 40% fill rate appears to be the magic number.  Wouldn't recommend creating a puzzle larger than that.
    func testCrosswordLimits() {
        let fillRate: Double = 0.2
        let size = 10
        let iterations = 25
        
        var puzzles = [CrosswordPuzzle]()
        for _ in 0..<iterations {
            let lengths = getWords(puzzleFill: fillRate, size: size)
            let puzzle = crosswordGenerator.createPuzzle(wordStructure: lengths, size: size)
            puzzles.append(puzzle)
        }
        
        assert(puzzles.count == iterations)
    }
    
    /// Using this to test what it can handle manually
    func testCrosswordGenerator() {
        let size = 10
        let iterations = 25
        
        var puzzles = [CrosswordPuzzle]()
        for _ in 0..<iterations {
            let lengths: [Length] = [.short, .short, .short, .short, .short, .short, .short]
            let start = Date()
            let puzzle = crosswordGenerator.createPuzzle(wordStructure: lengths, size: size)
            let time = start.timeIntervalSinceNow * -1
            print("Took \(time) seconds to create puzzle")
            puzzles.append(puzzle)
        }
        
        assert(puzzles.count == iterations)
    }
    
    
    /// Returns an array of words that fills a certain percentage of the puzzle
    ///
    /// - Parameter puzzleFill: Percentage of puzzle to contain letters
    /// - Paramter size: Size of puzzle
    fileprivate func getWords(puzzleFill: Double, size: Int) -> [Length] {
        let totalSize = (Double)(size * size)
        let tilesToFill = (Int)(totalSize * puzzleFill)
        var lengths = [Length]()
        var currentSize = 0
        
        while currentSize < tilesToFill {
            let val = arc4random()%3
            switch val {
            case 1:
                lengths.append(Length.medium)
                currentSize += 6
            case 2:
                lengths.append(Length.long)
                currentSize += 8
            default:
                lengths.append(Length.short)
                currentSize += 4
            }
        }
        
        return lengths
    }
        
}
