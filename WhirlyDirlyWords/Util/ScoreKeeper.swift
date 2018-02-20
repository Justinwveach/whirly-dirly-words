//
//  Scorer.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/20/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

struct ScoreKeeper {
    
    static func getMultiplierIncrement(_ word: String) -> Float {
        switch word.count {
        case 3:
            return 0.1
        case 4:
            return 0.2
        case 5:
            return 0.35
        case 6:
            return 0.5
        default:
            return 0.0
        }
    }
    
    // The puzzle has already been validated
    static func getScore(puzzle: CrosswordPuzzle) -> Int {
        var score = 0
        for tile in puzzle.tiles {
            score = score + tile.pointValue
        }
        return score
    }
    
    static func getScore(puzzle: CrosswordPuzzle, level: Level) -> Int {
        var score = getScore(puzzle: puzzle)
        let store = LevelMultiplierStore()
        if let multiplier = store.multipliers.filter("section == %d", level.section).first {
            score = Int(Float(score) * multiplier.value)
        }
        return score
    }
}
