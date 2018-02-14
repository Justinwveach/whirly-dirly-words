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
    
}
