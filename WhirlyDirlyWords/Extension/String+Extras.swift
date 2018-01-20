
//
//  File.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation

extension String {
    
    func length() -> Length {
        if self.count < 5 {
            return .short
        } else if self.count >= 5 && self.count <= 7 {
            return .medium
        } else if self.count >= 7 && self.count <= 10 {
            return .long
        } else {
            return .extraLong
        }
    }
    
    public func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }
    
}
