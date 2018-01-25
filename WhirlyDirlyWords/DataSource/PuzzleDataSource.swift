//
//  PuzzleDataSource.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/24/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class PuzzleDataSource: NSObject, UICollectionViewDataSource {
    
    var tiles: [Tile]!
    var size: Int = 0
    var puzzle: CrosswordPuzzle!
    weak var parent: UIViewController?
    
    init<T: UIViewController>(size: Int, puzzle: CrosswordPuzzle, parent: T) {
        super.init()
        self.size = size
        self.tiles = puzzle.tiles
        self.puzzle = puzzle
        self.parent = parent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return size * size
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PuzzleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCollectionViewCell", for: indexPath) as! PuzzleCollectionViewCell
        
        let column = indexPath.row < size ? indexPath.row : indexPath.row % size
        let row = indexPath.row / size
        
        let tile = puzzle.getTile(column: column, row: row)
        cell.letterLabel.text = tile.letter
        cell.tile = tile
        
        cell.delegate = parent as? TileDelegate
        
        if tile.isEmpty {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
        
        return cell
    }
    
}
