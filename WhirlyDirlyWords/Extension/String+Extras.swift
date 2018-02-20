
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
        } else if self.count >= 5 && self.count < 7 {
            return .medium
        } else if self.count >= 7 && self.count <= 8 {
            return .long
        } else {
            return .extraLong
        }
    }
    
    public func index(of char: Character) -> Int? {
        for i in 0..<self.count {
            let charAtIndex = self[index(startIndex, offsetBy: i)]
            if charAtIndex == char {
                return i
            }
        }
        //if let idx = characters.index(of: char) {
        //    return characters.distance(from: startIndex, to: idx)
        //}
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
    
    var jumble: String {
        return String(Array(self).shuffled())
    }
    
    var hash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
}
