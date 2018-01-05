//
//  WordFileGenerator.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation

class WordFileGenerator {
    
    fileprivate func removeUnwantedWords() {
        let file = "file.txt" //this is the file. we will write to and read from it
        
        var newFileText = ""
        
        let words = Parser.parseWords(file: "words-extended-raw", type: "txt")
        
        for word in words {
            newFileText.append(word)
            if word != words.last {
                newFileText.append("\n")
            }
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try newFileText.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }
    
}
