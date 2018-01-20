//
//  Tile.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/19/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

struct Tile {
    var letter: Character = Character("-")
    var column: Int = -1
    var row: Int = -1
    var invalid = false
    
    init(letter: Character, column: Int, row: Int) {
        self.letter = letter
        self.column = column
        self.row = row
    }
    
    init(invalid: Bool) {
        self.invalid = true
    }
    
    init() {
        
    }
    
    var isEmpty: Bool {
        get {
            return letter == Character("-") && column == -1 && row == -1
        }
    }
}
