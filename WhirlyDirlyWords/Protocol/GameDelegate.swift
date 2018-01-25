//
//  GameDelegate.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

protocol GameDelegate {
    
    func updated(totalScore: Int)
    func updated(roundScore: Int)
    func updated(round: Int)
    
    
}
