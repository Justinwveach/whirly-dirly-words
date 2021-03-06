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
    
    init?(value: Int) {
        if value <= 4 {
            self.init(rawValue: "short")
        }
        else if value <= 6 {
            self.init(rawValue: "medium")
        }
        else if value <= 8 {
            self.init(rawValue: "long")
        }
        else {
            self.init(rawValue: "extraLong")
        }
    }
    
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
    
    // When there is [Length] and I want to determine if it is unique compared ot other [Length], I take the sum of Length.powerTen.  This number represents a unique combination.
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
    
    var letterCount: Int {
        switch self {
        case .short:
            return 3
        case .medium:
            return 5
        case .long:
            return 7
        case .extraLong:
            return 9
        }
    }
    
}
