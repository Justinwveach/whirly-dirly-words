//
//  File.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import CocoaLumberjack

class CrosswordPuzzle {
    
    fileprivate var words: Stack<String>
    var tiles: [Tile]!
    var size: Int = 4
    
    var allWords: [String] {
        get {
            var wordsList = [String]()
            for i in 0..<words.count {
                wordsList.append(words.get(index: i))
            }
            
            return wordsList.shuffled()
        }
    }
    
    init(size: Int) {
        words = Stack<String>()
        self.tiles = [Tile]()
        self.size = size
    }
    
    func push(_ word: String) {
        words.push(word)
    }
    
    func popWord() {
        _ = words.pop()
    }
    
    func add(_ tile: Tile) {
        tiles.append(tile)
    }
    
    func add(_ tiles: [Tile]) {
        self.tiles.append(contentsOf: tiles)
    }
    
    func validateBoard() -> Bool {
        return validateBoard(tileSet: tiles)
    }
    
    func validateBoard(tileSet: [Tile]) -> Bool {
        var currentWord = ""
        
        // validate all words from left to right and then from top to bottom
        for i in 0...1 {
            for a in 0..<size {
                for j in 0..<size {
                    let column = i == 0 ? a : j
                    let row = i == 0 ? j : a
                    let tile = getTile(column: column, row: row, tileSet: tileSet)
                    if tile.isEmpty {
                        if !currentWord.isEmpty {
                            if !Words.sharedInstance.validate(word: currentWord) {
                                return false
                            }
                            currentWord = ""
                        }
                        continue
                    } else {
                        currentWord.append(tile.character)
                    }
                }
            }
        }
        
        return true
    }
    
    var shuffledTiles: [Tile] {
        get {
            return tiles.shuffled()
        }
    }
    
    func getTile(column: Int, row: Int) -> Tile {
        return getTile(column: column, row: row, tileSet: tiles)
    }
    
    func getTile(column: Int, row: Int, tileSet: [Tile]) -> Tile {
        if column < 0 || column >= size || row < 0 || row >= size {
            return Tile(invalid: true)
        }
        
        for tile in tileSet {
            if tile.column == column && tile.row == row {
                return tile
            }
        }
        
        return Tile()
    }
    
    var letters: [Character] {
        get {
            var allLetters = [Character]()
            for tile in tiles {
                if !tile.isEmpty && !tile.invalid {
                    allLetters.append(tile.character)
                }
            }
            
            return allLetters.shuffled()
        }
    }
    
    // Finds specificed number of random tiles
    func findRandomTiles(amount: Int) -> [Tile] {
        var randomTiles = [Tile]()
        var usedRandomCombos = [(Int, Int)]()
        
        while randomTiles.count < amount {
            // We've exhausted all combinations and didn't find enough random tiles
            if usedRandomCombos.count == (size * size) {
                DDLogWarn("Unable to find enough random tiles")
                break
            }
            
            let column: Int = Int(arc4random() % UInt32(size))
            let row: Int = Int(arc4random() % UInt32(size))
            let colRow = (column, row)
            if !usedRandomCombos.contains(where: {$0 == colRow}) {
                usedRandomCombos.append(colRow)
                
                let tile = getTile(column: column, row: row)
                if !tile.invalid && !tile.isPlaceholder && !tile.isEmpty {
                    randomTiles.append(tile)
                }
            }
        }
        
        return randomTiles
    }
    
    func printResult() {
        for row in 0..<size {
            var rowString = ""
            for column in 0..<size {
                let tile = getTile(column: column, row: row)
                rowString.append(tile.isEmpty ? "-" : tile.character)
            }
            print("\(rowString) \n")
        }
    }
    
}
