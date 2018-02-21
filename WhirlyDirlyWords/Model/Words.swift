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
    fileprivate var allCommonWords: Array<String>! = Array()
    // Example: Length.medium -> "c" -> ["catch", "carry", ..]
    fileprivate var allCommonWordsDictionary = Dictionary<Length, Dictionary<Character, Array<String>>>()
    fileprivate var allCommonWordsbyLength = Dictionary<Length, Array<String>>()
    
    // Only need a hash set for the rare words since it's only used on the bonus rounds
    // If we ever use these words for the puzzle, then we can remove this and just use the collections above
    // This contains a hash value for all words (sorted) so that the various permutations of letter sets will have the same hash (i.e. dog & god would have the same hash)
    fileprivate var rareWordsHashSet = [Int: [String]]()
    fileprivate var rareWordsByLength = [Int: [String]]()
    
    
    func populate(allWords: Array<String>, delegate: WordsDelegate) {
        DispatchQueue.global(qos: .background).async {
            Words.sharedInstance.populate(allWords: allWords)
            
            DispatchQueue.main.async {
                delegate.finishedPopulating()
            }
        }
    }
    
    func populate(allWords: Array<String>) {
        self.allCommonWords = allWords
        self.allCommonWords.sort(by: { (value1: String, value2: String) -> Bool in
            return value1 < value2 })
        sortWords()
    }
    
    func populate(rareWords: Array<String>) {
        for word in rareWords {
            // Currently only want 3, 4, 5, and 6 letter words.
            // Ignoring to speed up process since the list is about 100k
            if word.count < 3 || word.count > 6 {
                continue
            }
            
            if rareWordsByLength[word.count] == nil {
                rareWordsByLength[word.count] = [String]()
            }
            rareWordsByLength[word.count]?.append(word)
            
            let hash = String(word.sorted()).hash
            if rareWordsHashSet[hash] == nil {
                rareWordsHashSet[hash] = [String]()
            }
            rareWordsHashSet[hash]?.append(word)
        }
    }
    
    public func getWords(length: Length, firstLetter: Character) -> Array<String> {
        if let words = allCommonWordsDictionary[length]?[firstLetter] {
            return words
        }
        
        return Array()
    }
    
    public func getWord(length: Length) -> String {
        let words = allCommonWordsbyLength[length] ?? []
        
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
        let words = allCommonWordsbyLength[length] ?? []
        
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
        let index = binarySearch(allCommonWords, key: word)
        return index == nil ? false : true
    }
    
    fileprivate func sortWords() {
        for word in allCommonWords {
            if word.count < 3 {
                continue
            }
            
            if allCommonWordsDictionary[word.length()] == nil {
                allCommonWordsDictionary[word.length()] =  Dictionary()
            }
            
            if allCommonWordsDictionary[word.length()]![word.first!] == nil {
                allCommonWordsDictionary[word.length()]![word.first!] = Array()
            }
            
            allCommonWordsDictionary[word.length()]![word.first!]?.append(word)
            
            if allCommonWordsbyLength[word.length()] == nil {
                allCommonWordsbyLength[word.length()] = []
            }
            
            allCommonWordsbyLength[word.length()]?.append(word)
        }
    }
    
    // MARK: Rare Words Methods
    
    // Return all unique permutations for a word (i.e. cat = c, at, ca, ta, etc.)
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
            if let hashWords = rareWordsHashSet[combo.hash] {
                allWords.append(contentsOf: hashWords)
            }
        }
        return allWords
    }
    
    public func getRareWord(exactLength: Int) -> String {
        let words = rareWordsByLength[exactLength] ?? []

        if words.count > 0 {
            let random: Int = Int(arc4random() % UInt32(words.count))
            return words[random]
        }
        
        return ""
    }
    
}
