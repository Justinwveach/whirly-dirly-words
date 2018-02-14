//
//  ParserTest.swift
//  WhirlyDirlyWordsTests
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import XCTest
@testable import WhirlyDirlyWords

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWordParser() {
        var words = Array<String>()
        self.measure {
            words = Parser.parseWords(file: "words-extended", type: "txt")
        }
        
        assert(words.count > 0)
    }
    
    func testWordSorter() {
        let wordsArray = Parser.parseWords(file: "words-extended", type: "txt")
        Words.sharedInstance.populate(allWords: wordsArray)

        let wordsStartingWithT = Words.sharedInstance.getWords(length: .medium, firstLetter: "t")
        assert(wordsStartingWithT.contains("there"))
    }
    
    func testInvalids() {
        let charSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        let illegalWords = ["ev'er", "é", "J.T.", "Proper", "sdf`"]
        
        for word in illegalWords {
            if word.rangeOfCharacter(from: charSet.inverted) == nil {
               assert(true == false)
            } else {
                assert(true)
            }
        }
        
        let validWords = ["joe", "here"]
        
        for word in validWords {
            if word.rangeOfCharacter(from: charSet.inverted) == nil {
                assert(true)
            } else {
                assert(true == false)
            }
        }
    }
    
    /*
    func testDetectingInvalidWords() {
        let mobileRegEx =  "[a-z]+$"  // {3} -> at least 3 alphabet are compulsory.
        let nameString = "ev'er"
        do {
            let regex = try NSRegularExpression(pattern: mobileRegEx)
            let nsString = nameString as NSString
            let results = regex.matches(in: nameString, range: NSRange(location: 0, length: nsString.length))
            
            assert(results.count == 0)
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
        }
    }
 */
}
