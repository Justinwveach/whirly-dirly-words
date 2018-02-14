//
//  ViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var levelsTableView: UITableView!
    var levelDataSource: LevelDataSource!
    let levelStore = LevelStore()
    let multiplierStore = LevelMultiplierStore()
    var multipliers: Results<LevelMultiplier>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let levels = levelStore.levels
        multipliers = multiplierStore.multipliers
        levelDataSource = LevelDataSource(sections: multipliers, levels: levels)
        
        levelsTableView.delegate = self
        levelsTableView.dataSource = levelDataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LevelMultiplierHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = LevelMultiplierHeaderView.instanceFromNib()
        if let multiplier = multipliers.filter("section == %d", section).first {
            header.multiplierLabel.text = "\(multiplier.value)"
            header.titleLabel.text = "Test"
        }
        //let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //v.addGestureRecognizer(tapRecognizer)
        return header
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
}

