
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
    
}
