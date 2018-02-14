//
//  Length.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation

enum Length: String, Comparable {

    case short = "short"
    case medium = "medium"
    case long = "long"
    case extraLong = "extraLong"
    
    static func <(lhs: Length, rhs: Length) -> Bool {
        return lhs.sortIndex > rhs.sortIndex
    }
}

extension Length {
    var sortIndex: Int {
        switch self {
        case .short:
            return 0
        case .medium:
            return 1
        case .long:
            return 2
        case .extraLong:
            return 3
        }
    }
    
    // When there is [Length] and I want to determine if it is unique compared ot other [Length], I take the sum of Length.powerTen.  This number represents a unique combination.  Not sure if I like this and may change it up later since there will be limitations if the number of words gets too large.
    var powerTen: Int {
        switch self {
        case .short:
            return 1
        case .medium:
            return 10
        case .long:
            return 100
        case .extraLong:
            return 1000
        }
    }
}
