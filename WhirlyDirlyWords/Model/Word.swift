//
//  Word.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation

class Word: Stack<Character> {
    
    public var value = ""
    fileprivate var delegate: WordDelegate?
    
    init(delegate: WordDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    override func push(_ element: Character) {
        super.push(element)
        value.append(element)
        
        delegate?.pushed(letter: element)
    }
    
    override func pop() -> Character? {
        let removedCharacter = super.pop()
        value.removeLast()
        
        if removedCharacter != nil {
            delegate?.popped(letter: removedCharacter!)
        }
        
        return removedCharacter
    }
    
}
