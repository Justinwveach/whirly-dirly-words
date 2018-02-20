//
//  Scorer.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/20/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

struct ScoreKeeper {
    
    static func getBonusIncrement(_ word: String) -> Int {
        switch word.count {
        case 3:
            return 25
        case 4:
            return 50
        case 5:
            return 100
        case 6:
            return 200
        default:
            return 0
        }
    }
    
    // The puzzle has already been validated
    static func getScore(puzzle: CrosswordPuzzle) -> Int {
        var score = 0
        for tile in puzzle.tiles {
            score = score + tile.pointValue
        }
        return score * 10
    }
    
    /*
    static func getScore(puzzle: CrosswordPuzzle, level: Level) -> Int {
        var score = getScore(puzzle: puzzle)
        let store = BonusRoundStore()
        if let multiplier = store.bonuses.filter("section == %d", level.section).first {
            score = Int(Float(score) * multiplier.value)
        }
        return score
    }
 */
    
}
