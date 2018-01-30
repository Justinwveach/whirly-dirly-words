//
//  TileView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class TileView: DraggableView {
    
    @IBInspectable var originalBackgroundColor: UIColor = .white
    @IBInspectable var originalTextColor: UIColor = Constants.secondaryColor
    
    @IBOutlet weak var letterLabel: UILabel!
    weak var cell: TileCollectionViewCell?
    
    class func instanceFromNib() -> TileView {
        let tileView: TileView = UINib(nibName: "TileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TileView
        return tileView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func isDraggable() -> Bool {
        if let text = letterLabel.text {
            if !text.isEmpty && text != " " {
                return true
            }
        }
        
        return false
    }
    
    func resetUI() {
        backgroundColor = originalBackgroundColor
        letterLabel.textColor = originalTextColor
    }
    
}
