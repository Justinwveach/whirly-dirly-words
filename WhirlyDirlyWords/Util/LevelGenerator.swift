//
//  LevelGenerator.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/13/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

struct LevelGenerator {
    
    static let minShortWords: [Int: Int] = [3: 0, 4: 1, 5: 2, 6: 2, 7: 3, 8: 3]
    static let maxLongWords: [Int: Int] = [3: 2, 4: 2, 5: 3, 6: 3, 7: 4, 8: 4]
    
    
    let onlyThrees = ["000", "001", "002", "011", "111", "112", "122", "012", "022", "222"]
    let onlyFours = ["0000", "0001", "0002", "0011", "0111", "0112", "0122", "0012", "0022", "1122"]
    let onlyFives = ["00000", "00011", "00022", "00111", "0111", "00112", "00122", "00012", "00222", "01122"]
    
    static func createLevelSetOne() {
        let values = createBeginnerLevels()
        let levelStore = LevelStore()
        
        for value in values {
            let level = Level()
            level.section = value.0
            level.round = value.1
            level.roundInSection = value.2
            level.highScore = 0
            level.lettersGiven = 2
            level.puzzleSize = value.3
            level.id = LocalStorage.sharedInstance.nextLevelId

            for length in value.4.lengths {
                level.wordLengthsRaw.append(length.rawValue)
            }
            
            levelStore.addOrUpdate(level)
        }
    }
    
    
    /// Creates values needed to populate levels
    ///
    /// - Returns: Returns (Section, Level, LevelInSection, [Length])
    static func createBeginnerLevels() -> [(Int, Int, Int, Int, LengthArray)] {
        var level = 1
        var puzzleSize: Int = 8
        var numberOfWords = 3
        var levels = [(Int, Int, Int, Int, LengthArray)]()
        
        let multiplierStore = LevelMultiplierStore()
        for i in 0...5 {
            let levelMultiplier = LevelMultiplier()
            levelMultiplier.section = i
            levelMultiplier.id = LocalStorage.sharedInstance.nextMultiplierId
            multiplierStore.addOrUpdate(levelMultiplier)
            
            //Fibonacci sum of lengths
            if i > 4 {
                puzzleSize = 10
            }
            else if i > 2 {
                puzzleSize = 9
            }
            let maxLetterSum = (Int)((Double)(puzzleSize * puzzleSize) * 0.4)
            
            var wordLengthsUsed = [LengthArray]()
            
            for levelInSection in 0...4 {
                var foundUniqueCombo = false
                while !foundUniqueCombo {
                    let wordLengths = LengthArray()
                    for _ in 0..<numberOfWords {
                        let rand = arc4random()%3
                        switch rand {
                        case 0:
                            wordLengths.append(.short)
                        case 1:
                            wordLengths.append(.medium)
                        default:
                            wordLengths.append(.long)
                        }
                    }
                    
                    if !wordLengthsUsed.contains(wordLengths) && wordLengths.letterCount <= maxLetterSum {
                        wordLengthsUsed.append(wordLengths)
                        levels.append((i, level, levelInSection, puzzleSize, wordLengths))
                        level = level + 1
                        foundUniqueCombo = true
                    }
                }
                
            }
            numberOfWords = numberOfWords + 1
        }
        
        return levels
    }
    
}
