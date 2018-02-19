//
//  WhirlyDirlyWordsTests.swift
//  WhirlyDirlyWordsTests
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import XCTest
@testable import WhirlyDirlyWords

class WhirlyDirlyWordsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColumnRowCalculation() {
        let size = 8
        let index = 11

        let column = index < size ? index : index % size
        let row = index / size

        assert(column == 3)
        assert(row == 1)
    }
    
    func testColumnRowCalculationTwo() {
        let size = 8
        let index = 3
        
        let column = index < size ? index : index % size
        let row = index / size
        
        assert(column == 3)
        assert(row == 0)
    }
    
    func testCharAtIndex() {
        let string = "Hello"
        let index = string.index(of: "e")
        assert(index == 1)
        
        let lIndex = string.index(of: "l")
        assert(lIndex == 2)
    }
    
    func testTileValue() {
        let tileOne = Tile(letter: "z", column: 0, row: 0)
        assert(tileOne.pointValue == 10)
        
        let tileTwo = Tile(letter: "w", column: 0, row: 0)
        assert(tileTwo.pointValue == 4)
        
        let tileThree = Tile(invalid: true)
        assert(tileThree.pointValue == 0)
    }
    
    func testFindingRandomLetter() {
        let puzzleSize = 3
        let puzzle = CrosswordPuzzle(size: puzzleSize)
        for column in 0..<puzzleSize {
            for row in 0..<puzzleSize {
                let tile = Tile(letter: " ", column: column, row: row)
                if column == 1 && row == 2 {
                    tile.character = "t"
                }
                else if column == 2 && row == 0 {
                    tile.character = "e"
                }
                puzzle.add(tile)
            }
        }
        
        let randomTiles = puzzle.findRandomTiles(amount: 2)
        assert(randomTiles.count == 2)
        
        let tile1 = randomTiles[0]
        let tile2 = randomTiles[1]

        assert((tile1.column == 1 && tile1.row == 2) || (tile2.column == 1 && tile2.row == 2))
        
        assert((tile2.column == 2 && tile2.row == 0) || (tile1.column == 2 && tile1.row == 0))
    }

}
