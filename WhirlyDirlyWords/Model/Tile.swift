//
//  Tile.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/19/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Tile: Equatable {
    
    var character: Character = Character(" ")
    var column: Int = -1
    var row: Int = -1
    var invalid = false
    
    let points: [Character: Int] = ["a": 1, "b": 3, "c": 3, "d": 2, "e": 1,
                                    "f": 4, "g": 2, "h": 4, "i": 1, "j": 8,
                                    "k": 5, "l": 1, "m": 3, "n": 1, "o": 1,
                                    "p": 3, "q": 10, "r": 1, "s": 1, "t": 1,
                                    "u": 1, "v": 4, "w": 4, "x": 8, "y": 4, "z": 10];
    var pointValue: Int {
        get {
            if let value = points[self.character] {
                return value;
            }
            return 0;
        }
    }
    
    init(letter: Character, column: Int, row: Int) {
        self.character = letter
        self.column = column
        self.row = row
    }
    
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
        self.character = " "
    }
    
    init(invalid: Bool) {
        self.invalid = true
    }
    
    init() {
        
    }
    
    var isEmpty: Bool {
        get {
            return character == Character(" ") && column == -1 && row == -1
        }
    }
    
    var isPlaceholder: Bool {
        get {
            return character == Character(" ") && column >= 0 && row >= 0
        }
    }
    
    var letter: String {
        get {
            if character != " " {
                return String(character)
            } else {
                return ""
            }
        }
        set {
        }
    }
    
    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.character == rhs.character &&
                lhs.column == rhs.column &&
                lhs.row == rhs.row
    }
    
}
