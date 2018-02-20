//
//  BonusStore.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/14/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import RealmSwift
import CocoaLumberjack

class BonusStore: LocalStorageDelegate {
    
    public var bonuses: Results<Bonus> {
        get {
            let realm = try! Realm()
            return realm.objects(Bonus.self)
        }
    }
    
    public func addOrUpdate(_ object: AnyObject) {
        if let bonus = object as? Bonus {
            if !bonus.isInvalidated {
                let realm = try! Realm()
                try! realm.write {
                    // Will add a new level or update an existing one
                    realm.add(bonus, update: true)
                    DDLogDebug("Created level: section \(bonus.section)")
                }
            }
        } else {
            DDLogWarn("LevelStore tried to add or update an object that was not a Bonus.")
        }
    }
    
    public func delete(id: Int) {
        let realm = try! Realm()
        if let bonus = realm.objects(Bonus.self).filter("id = %d", id).first {
            if !bonus.isInvalidated {
                try! realm.write {
                    realm.delete(bonus)
                }
            }
        }
    }
    
    public func update(id: Int, fields: [String: Any]) {
        let realm = try! Realm()
        if let bonus = realm.objects(Bonus.self).filter("id = %d", id).first {
            if !bonus.isInvalidated {
                try! realm.write {
                    for (key, value) in fields {
                        bonus.setValue(value, forKeyPath: key)
                    }
                }
            }
        }
    }
    
}
