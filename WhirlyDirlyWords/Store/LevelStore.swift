//
//  LevelStore.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/13/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import RealmSwift
import CocoaLumberjack

class LevelStore: LocalStorageDelegate {
    
    static let levelsPerSection = 5
    
    public var levels: Results<Level> {
        get {
            let realm = try! Realm()
            return realm.objects(Level.self)
        }
    }
    
    public func addOrUpdate(_ object: AnyObject) {
        if let level = object as? Level {
            if !level.isInvalidated {
                let realm = try! Realm()
                try! realm.write {
                    // Will add a new level or update an existing one
                    realm.add(level, update: true)
                    DDLogDebug("Created level: section \(level.section) round: \(level.round)")
                }
            }
        } else {
            DDLogWarn("LevelStore tried to add or update an object that was not a Level.")
        }
    }
    
    public func delete(id: Int) {
        let realm = try! Realm()
        if let level = realm.objects(Level.self).filter("_id = %d", id).first {
            if !level.isInvalidated {
                try! realm.write {
                    realm.delete(level)
                }
            }
        }
    }
    
}
