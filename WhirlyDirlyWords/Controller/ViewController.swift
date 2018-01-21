//
//  ViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/6/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

