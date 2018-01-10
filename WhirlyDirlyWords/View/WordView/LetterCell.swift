//
//  LetterCell.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/8/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class LetterCell: UICollectionViewCell {
    
    @IBOutlet weak var letterLabel: UILabel!
    
    override var reuseIdentifier: String? {
        return "LetterCell"
    }
}

