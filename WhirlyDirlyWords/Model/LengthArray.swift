//
//  LengthArray.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/14/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

// NOTE: Array is a struct so I can't subclass it
class LengthArray: Equatable {
    
    var lengths = [Length]()
    
    static func ==(lhs: LengthArray, rhs: LengthArray) -> Bool {
        return lhs.powerTenSum == rhs.powerTenSum
    }
    
    convenience init(_ args: Length...) {
        self.init()
        for length in args {
            append(length)
        }
    }
    
    var count: Int {
        get {
            return lengths.count
        }
    }
    
    subscript(index: Int) -> Length {
        get {
            return lengths[index]
        }
        set(newValue) {
            lengths[index] = newValue
        }
    }
    
    func append(_ length: Length) {
        lengths.append(length)
        powerTenSum = powerTenSum + length.powerTen
        letterCount = letterCount + length.letterCount
    }
    
    func remove(at: Int) {
        let length = lengths[at]
        powerTenSum = powerTenSum - length.powerTen
        letterCount = letterCount - length.letterCount
        lengths.remove(at: at)
    }
    
    var powerTenSum: Int = 0
    var letterCount: Int = 0
}
