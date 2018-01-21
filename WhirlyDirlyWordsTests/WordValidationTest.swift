//
//  WordValidationTest.swift
//  WhirlyDirlyWordsTests
//
//  Created by Justin Veach on 1/4/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import XCTest
@testable import WhirlyDirlyWords

class WordValidationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWordIsValid() {
        let word = Word()
        word.push("t")
        word.push("e")
        word.push("s")
        word.push("t")
        
        let wordValues = Parser.parseWords(file: "words-extended", type: "txt")
        Words.sharedInstance.populate(allWords: wordValues)
        
        let result = Words.sharedInstance.validate(word: word)
        assert(result == true)
    }
    
    func testWordIsInvalid() {
        let word = Word()
        word.push("t")
        word.push("e")
        word.push("s")
        word.push("t")
        
        _ = word.pop()
        
        word.push("z")
        
        let wordValues = Parser.parseWords(file: "words-extended", type: "txt")
        Words.sharedInstance.populate(allWords: wordValues)

        let result = Words.sharedInstance.validate(word: word)
        assert(result == false)
    }
    
}
