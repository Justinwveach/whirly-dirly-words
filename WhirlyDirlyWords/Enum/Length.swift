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
        default:
            return 4
        }
    }
}
