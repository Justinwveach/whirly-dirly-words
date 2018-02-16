//
//  File.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

struct Game {
    
    var startingRound: Int = 1
    var endingRound: Int = 1
    var currentRound: Int = 1
    var score: Int = 0
    
    var puzzleGenerator = CrosswordGenerator(words: Words.sharedInstance)
    let roundsPerCheckpoint = 5
    var currentPuzzle: CrosswordPuzzle?
    
    var delegate: GameDelegate!

    var puzzleSize: Int {
        get {
            // todo: logic to calculate size based on round
            return 8
        }
    }
    var gameFinished = false
    
    init(delegate: GameDelegate) {
        self.delegate = delegate
    }
    
    init(delegate: GameDelegate, startingRound: Int) {
        self.init(delegate: delegate)
        self.startingRound = startingRound
    }
    
    mutating func startNextRound() -> (CrosswordPuzzle, [Character]) {
        currentPuzzle = puzzleGenerator.createPuzzle(wordStructure: LengthArray(Length.short, Length.medium, Length.short, Length.short), size: puzzleSize)
        currentPuzzle?.printResult()
        
        let userPuzzle = CrosswordPuzzle(size: puzzleSize)
        for t in (currentPuzzle?.tiles)! {
            let tile = Tile(letter: " ", column: t.column, row: t.row)
            userPuzzle.add(tile)
        }
        
        //puzzle.letters shuffles the letters for us, so let's keep that order once we shuffle
        let letters = currentPuzzle?.letters ?? []
        
        return (userPuzzle, letters)
        
    }
    
    func completedRound(numberOfLetters: Int, numberOfWords: Int) {
        // caculate score
        //delegate.updated(score: score)
    }
    
    fileprivate func getPuzzleWords() -> [Length] {
        return [.short]
    }
    
}
