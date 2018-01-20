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
            }
            
            return words
        }
    
        return Array()
    }

}
