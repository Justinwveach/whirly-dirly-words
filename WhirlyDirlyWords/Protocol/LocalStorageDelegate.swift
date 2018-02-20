//
//  LocalStorageDelegate.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/14/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

protocol LocalStorageDelegate {
    func addOrUpdate(_ object: AnyObject)
    func delete(id: Int)
    func update(id: Int, fields: [String: Any])
}
