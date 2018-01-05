//
//  WordView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit

class WordView: UIView, WordDelegate {
   
    var word: Word!
    var actualWord: String!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        word = Word(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pushed(letter: Character) {
        
    }
    
    func popped(letter: Character) {
        
    }
}
