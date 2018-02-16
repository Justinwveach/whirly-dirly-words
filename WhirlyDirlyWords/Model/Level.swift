//
//  Level.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/13/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import RealmSwift

class Level: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var section = 0
    @objc dynamic var round = 0
    @objc dynamic var roundInSection = 0
    @objc dynamic var puzzleSize = 0
    @objc dynamic var highScore = 0
    @objc dynamic var lettersGiven = 0
    let wordLengthsRaw = List<String>()
    
    var wordLengths: LengthArray {
        get {
            let lengths = LengthArray()
            for rawLength in wordLengthsRaw {
                if let length = Length(rawValue: rawLength) {
                    lengths.append(length)
                }
            }
            return lengths
        }
    }
    
    var numberOfWords: Int {
        get {
            return wordLengthsRaw.count
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}


