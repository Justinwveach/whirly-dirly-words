//
//  PuzzleCollectionViewCell.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class PuzzleCollectionViewCell: TileCollectionViewCell {
    
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    func set(letter: String) {
        letterLabel.text = letter
        /*
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
                self.letterLabel.text = letter
            }, completion: nil)
        */
    }
}
