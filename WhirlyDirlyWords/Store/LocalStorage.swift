//
//  LocalStorage.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/14/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import RealmSwift
import CocoaLumberjack

/// This class handles the configuration of our LocalStorage, which is Realm.
class LocalStorage {
    
    static let sharedInstance = LocalStorage()
    var nextLevelId: Int {
        get{
            let realm = try! Realm()
            if let max: Int = realm.objects(Level.self).max(ofProperty: "id") {
                return max + 1
            }
            return 0
        }
    }
    var nextBonusId: Int {
        get {
            let realm = try! Realm()
            
            if let max: Int = realm.objects(Bonus.self).max(ofProperty: "id") {
                return max + 1
            }
            return 0
        }
    }
    
    init() {

    }
    
    func setupFor(userId: String) {
        
        //deleteRealm()
        
        // Set the default Realm for the logged in user
        var config = Realm.Configuration()
        
        // Store Realm data on a per user basis
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(userId).realm")
        
        Realm.Configuration.defaultConfiguration = config
        
        DDLogDebug("Setup local storage for \(userId)")
        
        // We need to start with a clean database on initial launch in case items were deleted while the user wasn't using the app
        clearAllData()
        
        //deleteRealm()
    }
    
    func deleteRealm() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        //let userURL = realmURL.deletingLastPathComponent()
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                // handle error
            }
        }
    }
    
    func clearAllData() {
        let realm = try! Realm()
        let transports = realm.objects(Level.self)
        
        try! realm.write {
            //realm.deleteAll()
            realm.delete(transports)
        }
    }
    
}
