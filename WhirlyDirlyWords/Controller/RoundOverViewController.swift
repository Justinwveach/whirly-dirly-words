//
//  RoundOverViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class RoundOverViewController: UIViewController {

    //@IBOutlet weak var alertYConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    var homeAction: (() -> Void) = {}
    var retryAction: (() -> Void) = {}
    var nextAction: (() -> Void) = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Don't want to animate this because we do our own animations
        // Causes a delay if it's true
        super.viewDidAppear(false)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.backgroundView.alpha = 0.9
            //self.alertYConstraint.constant = self.initialY
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            self.backgroundView.alpha = 0.0
            //self.alertYConstraint.constant = self.yOffset
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func goHome(_ sender: Any) {
        dismissController(homeAction)
    }
    
    @IBAction func retry(_ sender: Any) {
        dismissController(retryAction)
    }
    
    @IBAction func next(_ sender: Any) {
        dismissController(nextAction)
    }
    
    // MARK: Private Methods
    
    fileprivate func dismissController(_ closure: @escaping () -> Void) {
        dismiss(animated: true) {
            closure()
        }
    }

}
