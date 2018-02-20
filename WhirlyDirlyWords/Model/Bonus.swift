//
//  Bonus.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/13/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import RealmSwift

class Bonus: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var section = 0
    @objc dynamic var value: Int = 0
    @objc dynamic var dateCompleted: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // 100 = 1 letter
    var freeLetters: Int {
        get {
            return value / 100
        }
    }
}
