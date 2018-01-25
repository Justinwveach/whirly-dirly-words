//
//  LetterDataSource.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/24/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class LetterDataSource: NSObject, UICollectionViewDataSource {
    
    var letters: [Character] = []
    weak var parent: UIViewController?
    
    init<T: UIViewController & DraggableDelegate & TileDelegate>(letters: [Character], parent: T) {
        super.init()
        self.letters = letters
        self.parent = parent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCollectionViewCell", for: indexPath) as! LetterCollectionViewCell
        cell.tileView.letterLabel.text = String(letters[indexPath.row])
        cell.tileView.delegate = parent as? DraggableDelegate
        cell.tileView.cell = cell
        cell.delegate = parent as? TileDelegate
        return cell
    }
    
    func removeLetter(index: Int) {
        letters.remove(at: index)
    }
    
}
