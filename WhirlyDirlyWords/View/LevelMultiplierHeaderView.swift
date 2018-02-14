//
//  LevelMultiplierTableViewCell.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/13/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class LevelMultiplierHeaderView: UIView {
    
    static let height: CGFloat = 100.0
    
    @IBOutlet weak var multiplierLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    class func instanceFromNib() -> LevelMultiplierHeaderView {
        return UINib(nibName: "LevelMultiplierHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LevelMultiplierHeaderView
    }
    
    fileprivate func customizeView() {
    }
}
