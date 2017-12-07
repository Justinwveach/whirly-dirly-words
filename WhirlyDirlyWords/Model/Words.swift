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
    
    init(allWords: Array<String>) {
        self.allWords = allWords
        sortWords()
    }
    
    public func getWords(length: Length, firstLetter: Character) -> Array<String> {
        if let words = allWordsDictionary[length]?[firstLetter] {
            return words
        }
        
        return Array()
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
        }
    }
    
}
