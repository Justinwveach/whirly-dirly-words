//
//  LevelMultiplierStore.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/14/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import RealmSwift
import CocoaLumberjack

class LevelMultiplierStore: LocalStorageDelegate {
    
    public var multipliers: Results<LevelMultiplier> {
        get {
            let realm = try! Realm()
            return realm.objects(LevelMultiplier.self)
        }
    }
    
    public func addOrUpdate(_ object: AnyObject) {
        if let levelMultiplier = object as? LevelMultiplier {
            if !levelMultiplier.isInvalidated {
                let realm = try! Realm()
                try! realm.write {
                    // Will add a new level or update an existing one
                    realm.add(levelMultiplier, update: true)
                    DDLogDebug("Created level: section \(levelMultiplier.section)")
                }
            }
        } else {
            DDLogWarn("LevelStore tried to add or update an object that was not a LevelMultiplier.")
        }
    }
    
    public func delete(id: Int) {
        let realm = try! Realm()
        if let levelMultiplier = realm.objects(LevelMultiplier.self).filter("id = %d", id).first {
            if !levelMultiplier.isInvalidated {
                try! realm.write {
                    realm.delete(levelMultiplier)
                }
            }
        }
    }
    
    public func update(id: Int, fields: [String: Any]) {
        let realm = try! Realm()
        if let levelMultiplier = realm.objects(LevelMultiplier.self).filter("id = %d", id).first {
            if !levelMultiplier.isInvalidated {
                try! realm.write {
                    for (key, value) in fields {
                        levelMultiplier.setValue(value, forKeyPath: key)
                    }
                }
            }
        }
    }
    
}
