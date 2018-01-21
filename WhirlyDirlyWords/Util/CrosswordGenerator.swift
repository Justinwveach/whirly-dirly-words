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
    var size: Int = 4
    var puzzle: CrosswordPuzzle!
    
    init(words: Words) {
        self.words = words
    }
    
    func createPuzzle(wordStructure: [Length], size: Int) -> CrosswordPuzzle {
        puzzle = CrosswordPuzzle(size: size)
        
        let puzzleStructure = wordStructure.sorted()
        //wordStructure = wordStructure.sorted()
        let firstWord = words.getWord(length: puzzleStructure[0])
        
        let initialPlace = firstWord.count == size ? 0 : Int(arc4random() % UInt32(size - firstWord.count))
        
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
            puzzle.add(Tile(letter: letter, column: column, row: row))
            if direction {
                row += 1
            } else {
                column += 1
            }
        }
        
        puzzle.push(firstWord)
        for i in 1..<wordStructure.count {
            let length = wordStructure[i]
            var foundWord = false
            
            while foundWord == false {
                foundWord = findWordThatWorks(length: length)
            }
        }
        
        return puzzle
    }
    
    fileprivate func findWordThatWorks(length: Length) -> Bool {
        for letter in puzzle.letters {
            let word = words.getWord(length: length, contains: letter)
            let successfullyPlaced = place(word)
            
            if successfullyPlaced {
                return true
            }
        }
        return false
    }
    
    fileprivate func place(_ word: String) -> Bool {
        for tile in puzzle.shuffledTiles {
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
            let tile = puzzle.getTile(column: column, row: row)
            if tile.isEmpty && !tile.invalid {
                pendingTiles.append(Tile(letter: word[i], column: column, row: row))
            } else {
                return false
            }
        }
        
        var tempTiles: [Tile] = []
        tempTiles.append(contentsOf: puzzle.tiles)
        tempTiles.append(contentsOf: pendingTiles)
        
        if puzzle.validateBoard(tileSet: tempTiles) {
            puzzle.add(pendingTiles)
            puzzle.push(word)
        } else {
            return false
        }
        
        return true
    }
    
    fileprivate var upDown: Bool {
        get {
            return Int(arc4random() % UInt32(2)) == 0 ? true : false
        }
    }
    
}
