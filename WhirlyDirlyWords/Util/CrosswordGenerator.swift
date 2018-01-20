//
//  CrosswordGenerator.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/19/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import CocoaLumberjack

public class CrosswordGenerator {
    
    var words: Words!
    var size: Int!
    var tiles: [Tile] = []
    var wordsUsed = Stack<String>()
    
    init(words: Words, size: Int) {
        self.words = words
        self.size = size
    }
    
    func createPuzzle(wordStructure: [Length]) {
        let puzzleStructure = wordStructure.sorted()
        //wordStructure = wordStructure.sorted()
        let firstWord = words.getWord(length: puzzleStructure[0])
        
        let initialPlace = Int(arc4random() % UInt32(size - firstWord.count))
        
        var column = 0
        var row = 0
        let padding = 4
        
        let direction = upDown
        if direction {
            column = Int(arc4random() % UInt32(size - padding)) + 2
            row = initialPlace
        } else {
            column = initialPlace
            row = Int(arc4random() % UInt32(size - padding)) + 2
        }
        
        for letter in firstWord {
            tiles.append(Tile(letter: letter, column: column, row: row))
            if direction {
                row += 1
            } else {
                column += 1
            }
        }
        
        wordsUsed.push(firstWord)
       // while wordsUsed.count < wordStructure.count {
            for i in 1..<wordStructure.count {
                let length = wordStructure[i]
                var foundWord = false
                
                while foundWord == false {
                    foundWord = findWordThatWorks(length: length)
                }
            }
        //}
    }
    
    fileprivate func findWordThatWorks(length: Length) -> Bool {
        for letter in letters {
            let word = words.getWord(length: length, contains: letter)
            let successfullyPlaced = place(word)
            
            if successfullyPlaced {
                wordsUsed.push(word)
                return true
            }
        }
        return false
    }
    
    func printResult() {
        for column in 0..<size {
            var rowString = ""
            for row in 0..<size {
                let tile = getTile(column: column, row: row)
                rowString.append(tile.isEmpty ? "-" : tile.letter)
            }
            DDLogDebug("\(rowString) \n")
        }
    }
    
    fileprivate func place(_ word: String) -> Bool {
        for tile in shuffledTiles {
            if tile.isEmpty {
                continue
            }
            
            if word.contains(tile.letter) {
                let direction = upDown
                var successful = addToBoard(word, tile, direction)
                if !successful {
                    successful = addToBoard(word, tile, !direction)
                }
                
                return successful
            }
        }
        
        return false
    }
    
    fileprivate func adjacentTiles(tile: Tile) -> [Tile] {
        return []
    }
    
    fileprivate func addToBoard(_ word: String, _ tile: Tile, _ isUpDown: Bool) -> Bool {
        var pendingTiles: [Tile] = []
        let letterIndex = word.index(of: tile.letter) ?? -1
        
        if letterIndex == -1 {
            return false
        }
        
        for i in 0..<word.count where i != letterIndex {
            let offset = i - letterIndex
            let column = isUpDown ? tile.column : tile.column + offset
            let row = isUpDown ? tile.row + offset : tile.row
            let tile = getTile(column: column, row: row)
            if tile.isEmpty && !tile.invalid {
                pendingTiles.append(Tile(letter: word[i], column: column, row: row))
            } else {
                return false
            }
        }
        
        var tempTiles: [Tile] = []
        tempTiles.append(contentsOf: tiles)
        tempTiles.append(contentsOf: pendingTiles)
        
        if validateBoard(tileSet: tempTiles) {
            tiles.append(contentsOf: pendingTiles)
        } else {
            return false
        }
        
        return true
    }
    
    fileprivate func validateBoard(tileSet: [Tile]) -> Bool {
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
                            if !words.validate(word: currentWord) {
                                return false
                            }
                            currentWord = ""
                        }
                        continue
                    } else {
                        currentWord.append(tile.letter)
                    }
                }
            }
        }
        
        return true
    }
    
    fileprivate func validateBoard() -> Bool {
        return validateBoard(tileSet: tiles)
    }
    
    fileprivate var letters: [Character] {
        get {
            var allLetters = [Character]()
            for tile in tiles {
                if !tile.isEmpty {
                    allLetters.append(tile.letter)
                }
            }
            
            return allLetters.shuffled()
        }
    }
    
    fileprivate var upDown: Bool {
        get {
            return Int(arc4random() % UInt32(2)) == 0 ? true : false
        }
    }
    
    fileprivate var shuffledTiles: [Tile] {
        get {
            return tiles.shuffled()
        }
    }
    
    func getTile(column: Int, row: Int) -> Tile {
        return getTile(column: column, row: row, tileSet: tiles)
    }
    
    fileprivate func getTile(column: Int, row: Int, tileSet: [Tile]) -> Tile {
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
}
