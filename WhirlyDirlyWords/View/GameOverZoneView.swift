//
//  GameOverZoneView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/4/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class GameOverZoneView: UIView {

    let gradientLayer = CAGradientLayer()

    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    fileprivate func setupGradient() {
        self.backgroundColor = UIColor.clear
        
        // 2
        gradientLayer.frame = self.bounds
        
        // 3
        let color1 = UIColor.red.cgColor as CGColor
        let color2 = UIColor(red: 0.4, green: 0.0, blue: 0.8, alpha: 0.2).cgColor
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.5, 1.0]
        
        // 5
        self.layer.addSublayer(gradientLayer)
    }

}
