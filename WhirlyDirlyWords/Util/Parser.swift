//
//  Parser.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Parser {
    
    fileprivate static let charSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
    fileprivate static let commonTwoLetterWords = ["aa", "ab", "ad", "ae", "ag", "ah", "ai", "al", "am", "an", "ar", "as", "at", "aw", "ax", "ay", "ba", "be", "bi", "bo", "by", "de", "do", "ed", "ef", "eh", "el", "em", "en", "er", "es", "et", "ex", "fa", "fe", "go", "ha", "he", "hi", "hm", "ho", "id", "if", "in", "is", "it", "jo", "ka", "ki", "la", "li", "lo", "ma", "me", "mi", "mm", "mo", "mu", "my", "na", "ne", "no", "nu", "od", "oe", "of", "oh", "oi", "om", "on", "op", "or", "os", "ow", "ox", "oy", "pa", "pe", "pi", "qi", "re", "sh", "si", "so", "ta", "ti", "to", "uh", "um", "un", "up", "us", "ut", "we", "wo", "xi", "xu", "ya", "ye", "yo", "za"]
    
    static func parseWords(file: String, type: String, delegate: WordsDelegate) {
        DispatchQueue.global(qos: .background).async {
            let words = Parser.parseWords(file: file, type: type)
            
            DispatchQueue.main.async {
                delegate.finishedParsing(words: words)
            }
        }
    }
    
    static func parseWords(file: String, type: String) -> Array<String> {
        let pathToFile = Bundle.main.path(forResource: file, ofType: type)
    
        if let path = pathToFile {
            let wordsString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            var words: Array<String> = wordsString.components(separatedBy: "\n")
            
            for i in (0..<words.count).reversed() {
                let thisWord = words[i]
                if thisWord.rangeOfCharacter(from: charSet.inverted) != nil {
                    //print("Removing \(thisWord) from array")
                    words.remove(at: i)
                }
                // Alot of 2 letters are uncommon and rarely used, so let's only use normal ones
                else if thisWord.count == 2 && !commonTwoLetterWords.contains(thisWord) {
                    DDLogDebug("Removed 2 letter word: \(thisWord)")
                    words.remove(at: i)
                }
                
            }
            
            return words
        }
    
        return Array()
    }

}
