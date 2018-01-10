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
    
    override init() {
        super.init()
    }
    
    convenience init(delegate: WordDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func push(_ element: Character) {
        super.push(element)
        value.append(element)
        
        delegate?.pushed(letter: element)
    }
    
    public func get(_ position: Int) -> Character {
        //precondition(position >= self.count, "out of bounds")
        let index = value.index(value.startIndex, offsetBy: position)
        let char = value[index]
        return char
    }
    
    override func pop() -> Character? {
        let removedCharacter = super.pop()
        value.removeLast()
        
        if removedCharacter != nil {
            delegate?.popped(letter: removedCharacter!)
        }
        
        return removedCharacter
    }
    
    /*
    subscript (position: Index) -> Character {
        precondition(position >= self.count, "out of bounds")
        // 3
        let char = value[position]
        return
    }
    */
}
