//
//  BonusHeaderView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/13/18.
//  Copyright Â© 2018 justinveach. All rights reserved.
//

import UIKit

class BonusHeaderView: UIView {
    
    static let height: CGFloat = 100.0
    
    @IBOutlet weak var bonusLabel: UILabel!
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
    
    class func instanceFromNib() -> BonusHeaderView {
        return UINib(nibName: "BonusHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BonusHeaderView
    }
    
    fileprivate func customizeView() {
    }
}
