//
//  TileCollectionViewCel.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit
import CocoaLumberjack

class TileCollectionViewCell: UICollectionViewCell {
    
    weak var tile: Tile!
    var delegate: TileDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(TileCollectionViewCell.longPressed(_:)))
        self.contentView.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed(_ recognizer: UILongPressGestureRecognizer) {
        delegate?.longPressed(cell: self)
    }
    
}
