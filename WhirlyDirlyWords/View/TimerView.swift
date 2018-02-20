//
//  TimerView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 02/20/2018.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    @IBOutlet weak var timerLabel: AutoUpdateTimeMultiFormatLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TimerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
