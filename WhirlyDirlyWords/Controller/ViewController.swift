//
//  ViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import RealmSwift
import CocoaLumberjack

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var levelsTableView: UITableView!
    var levelDataSource: LevelDataSource!
    let levelStore = LevelStore()
    let bonusStore = BonusStore()
    var bonuses: Results<Bonus>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let levels = levelStore.levels
        bonuses = bonusStore.bonuses
        levelDataSource = LevelDataSource(sections: bonuses, levels: levels)
        
        levelsTableView.delegate = self
        levelsTableView.dataSource = levelDataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        levelsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startLevel(section: Int, level: Int) {
        if let level = levelStore.levels.filter("section == %d && roundInSection == %d", section, level).first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            gameViewController.level = level
            gameViewController.homeViewController = self
            present(gameViewController, animated: true, completion: nil)
        } else {
            DDLogDebug("Could not retrieve the Level from Realm when user clicked on table view cell: section \(section) row \(level)")
        }
    }
    
    func startBonus(section: Int) {
        if let bonus = bonusStore.bonuses.filter("section == %d", section).first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let bonusViewController = storyboard.instantiateViewController(withIdentifier: "BonusRoundViewController") as! BonusRoundViewController
            bonusViewController.bonus = bonus
            bonusViewController.homeViewController = self
            present(bonusViewController, animated: true, completion: nil)
        } else {
            DDLogWarn("Could not find level bonus for section: \(section)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return BonusHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = BonusHeaderView.instanceFromNib()
        if let bonus = bonuses.filter("section == %d", section).first {
            header.bonusLabel.text = "\(bonus.freeLetters) Free Letters"
            header.titleLabel.text = "Round \(section+1)"
        }
        header.tag = section    
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(sender:)))
        header.addGestureRecognizer(tapRecognizer)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startLevel(section: indexPath.section, level: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewGameSegue" {
            let viewController = segue.destination as! GameViewController
            viewController.isResuming = false
        }
        else if segue.identifier == "ResumeGameSegue" {
            let viewController = segue.destination as! GameViewController
            viewController.isResuming = true
        }
    }
    
    @objc fileprivate func handleHeaderTap(sender: UITapGestureRecognizer) {
        startBonus(section: sender.view?.tag ?? -1)
    }

}

