//
//  LevelDataSource.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/13/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation
import RealmSwift
import CocoaLumberjack

class LevelDataSource: NSObject, UITableViewDataSource {
    
    var sections: Results<Bonus>
    var levels: Results<Level>
    
    init(sections: Results<Bonus>, levels: Results<Level>) {
        self.sections = sections
        self.levels = levels
        
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.filter("section == %d", section).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LevelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCell") as! LevelTableViewCell
        
        if let level = levels.filter("section == %d AND roundInSection == %d", indexPath.section, indexPath.row).first {
            cell.levelLabel.text = "\(level.round)"
            cell.scoreLabel.text = "\(level.highScore)"
            cell.wordsLabel.text = "\(level.numberOfWords)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    fileprivate func shouldBeEnabled(level: Level) -> Bool {
        
        return true
    }
    
}
