//
//  LevelGeneratorTests.swift
//  WhirlyDirlyWordsTests
//
//  Created by Justin Veach on 2/13/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import XCTest
@testable import WhirlyDirlyWords

class LevelGeneratorTests: XCTestCase {
    
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
    
    func testCreateBeginnerLevels() {
        let levels = LevelGenerator.createBeginnerLevels()
        for level in levels {
            print("Section: \(level.0) Level: \(level.1) Lengths:\(level.2)")
        }
        assert(levels.count == 30)
    }
    
    var count = 0
    var allCombos = [LengthArray]()
    
    // https://www.mathsisfun.com/combinatorics/combinations-permutations-calculator.html
    // use the link above to determine correct number
    func testWordComboUniqueness() {
        var possibleValues = [Length]()
        let wordCount = 8
        
        possibleValues.append(Length.short)
        possibleValues.append(Length.medium)
        possibleValues.append(Length.long)
        possibleValues.append(Length.extraLong)
        
        // TODO: create algorithm that ignores the order
        printCombo(values: possibleValues, k: wordCount)
        
        var uniqueCombos = [Int]()
        for combo in allCombos {
            if !uniqueCombos.contains(combo.powerTenSum) {
                uniqueCombos.append(combo.powerTenSum)
            }
        }
        
        assert(uniqueCombos.count == 165)
    }
    
    fileprivate func printCombo(values: [Length], k: Int) {
        let n = values.count
        printAllCombos(values: values, currentCombo: LengthArray(), n: n, k: k)
        print("\(count) unique combinations")
    }
    
    fileprivate func printAllCombos(values: [Length], currentCombo: LengthArray, n: Int, k: Int) {
        // Base case: k is 0, print prefix
        if k == 0 {
            //print("\(prefix)")
            allCombos.append(currentCombo)
            count = count + 1
            return
        }
        
        // One by one add all characters from set and recursively
        // call for k equals to k-1
        for i in 0..<n {
            // Next character of input added
            let newCombo = LengthArray()
            for length in currentCombo.lengths {
                newCombo.append(length)
            }
            newCombo.append(values[i])
            // let newPrefix = "\(prefix)\(values[i])"
            
            // k is decreased, because we have added a new character
            printAllCombos(values: values, currentCombo: newCombo, n: n, k: k-1)
        }
    }

}
