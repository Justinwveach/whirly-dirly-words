//
//  Words.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation

final class Words {
    
    static let sharedInstance = Words()
    
    // Words that are used for the puzzles ~ 10,000 common words
    fileprivate var allWords: Array<String>! = Array()
    // Example: Length.medium -> "c" -> ["catch", "carry", ..]
    fileprivate var allWordsDictionary = Dictionary<Length, Dictionary<Character, Array<String>>>()
    fileprivate var allWordsbyLength = Dictionary<Length, Array<String>>()
    fileprivate var hashSet = [Int: [String]]()
    
    func populate(allWords: Array<String>, delegate: WordsDelegate) {
        DispatchQueue.global(qos: .background).async {
            Words.sharedInstance.populate(allWords: allWords)
            
            DispatchQueue.main.async {
                delegate.finishedPopulating()
            }
        }
    }
    
    func populate(allWords: Array<String>) {
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
    
    public func getWord(exactLength: Int) -> String {
        var word = ""
        while word.isEmpty {
            let foundWord = getWord(length: Length(value: exactLength)!)
            if foundWord.count == exactLength {
                word = foundWord
            }
        }
        return word
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
            
            let hash = String(word.sorted()).hash
            if hashSet[hash] == nil {
                hashSet[hash] = [String]()
            }
            
            hashSet[hash]?.append(word)
        }
    }
    
    func getCombinations(word: String) -> [String] {
        var results = [String]()
        var actualResults = [String]()
        
        for i in 0..<word.count {
            for j in 0..<results.count {
                let combination = String((word[i] + results[j]).sorted())
                results.append(combination)
                if combination.count >= 3 {
                    actualResults.append(combination)
                }
            }
            results.append(word[i])
        }
        return actualResults
    }
    
    func getWordsContaining(letters: String) -> [String] {
        var allWords = [String]()
        let combinations = getCombinations(word: letters)
        for combo in combinations {
            if let hashWords = hashSet[combo.hash] {
                allWords.append(contentsOf: hashWords)
            }
        }
        return allWords
    }
    
}
