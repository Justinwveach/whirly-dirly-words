//
//  Tile.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/19/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Tile {
    var character: Character = Character(" ")
    var column: Int = -1
    var row: Int = -1
    var invalid = false
    
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
}
