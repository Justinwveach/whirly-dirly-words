//
//  LevelMultiplier.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/13/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import RealmSwift

class LevelMultiplier: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var section = 0
    @objc dynamic var value: Float = 1.0
    @objc dynamic var dateCompleted: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
