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
    
    var gameFinished = false
    
    var delegate: GameDelegate!
    
    init(delegate: GameDelegate) {
        self.delegate = delegate
    }
    
    init(delegate: GameDelegate, startingRound: Int) {
        self.init(delegate: delegate)
        self.startingRound = startingRound
    }
    
    func completedRound(numberOfLetters: Int, numberOfWords: Int) {
        // caculate score
        //delegate.updated(score: score)
    }
    
}
