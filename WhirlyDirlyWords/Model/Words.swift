//
//  Words.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation

class Words {
    
    fileprivate var allWords: Array<String>! = Array()
    // Example: Length.medium -> "c" -> ["catch", "carry", ..]
    fileprivate var allWordsDictionary = Dictionary<Length, Dictionary<Character, Array<String>>>()
    fileprivate var allWordsbyLength = Dictionary<Length, Array<String>>()
    
    init(allWords: Array<String>) {
        self.allWords = allWords
        self.allWords.sort(by: { (value1: String, value2: String) -> Bool in
            return value1 < value2 })
        sortWords()
    }
    
    public func getWords(length: Length, firstLetter: Character) -> Array<String> {
        if let words = allWordsDictionary[length]?[firstLetter] {
            return words
        }
        
        return Array()
    }
    
    public func getWord(length: Length) -> String {
        let words = allWordsbyLength[length] ?? []
        
        if words.count > 0 {
            let random: Int = Int(arc4random() % UInt32(words.count))
            return words[random]
        }
        
        return "freebie"
    }
    
    public func getWord(length: Length, contains letter: Character) -> String {
        let words = allWordsbyLength[length] ?? []
        
        if words.count > 0 {
            var word = ""
            while !word.contains(letter) {
                let random: Int = Int(arc4random() % UInt32(words.count))
                word = words[random]
            }
            
            return word
        }
        
        return "bug"
    }
    
    public func validate(word: Word) -> Bool {
        return validate(word: word.value)
    }
    
    public func validate(word: String) -> Bool {
        let index = binarySearch(allWords, key: word)
        return index == nil ? false : true
    }
    
    fileprivate func sortWords() {
        for word in allWords {
            if word.count < 3 {
                continue
            }
            
            if allWordsDictionary[word.length()] == nil {
                allWordsDictionary[word.length()] =  Dictionary()
            }
            
            if allWordsDictionary[word.length()]![word.first!] == nil {
                allWordsDictionary[word.length()]![word.first!] = Array()
            }
            
            allWordsDictionary[word.length()]![word.first!]?.append(word)
            
            if allWordsbyLength[word.length()] == nil {
                allWordsbyLength[word.length()] = []
            }
            
            allWordsbyLength[word.length()]?.append(word)
        }
    }
    
}
