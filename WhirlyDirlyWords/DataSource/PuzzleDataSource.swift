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
    
    init<T: UIViewController & DraggableDelegate>(size: Int, puzzle: CrosswordPuzzle, parent: T) {
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
        cell.tileView.letterLabel.text = tile.letter
        cell.tileView.delegate = parent as? DraggableDelegate
        cell.tileView.cell = cell
        cell.tileView.tag = 0
        cell.tileView.isFixed = tile.isFreebie
        
        cell.tile = tile
        cell.delegate = parent as? TileDelegate
        
        if tile.isFreebie {
            cell.tileView.originalBackgroundColor = Constants.secondaryColor
            cell.tileView.originalTextColor = .white
        } else {
            cell.tileView.originalBackgroundColor = .white
            cell.tileView.originalTextColor = Constants.secondaryColor
        }
        
        cell.tileView.resetUI()
        
        if tile.isEmpty {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
        
        return cell
    }
    
    func move(tile: Tile, to: TileCollectionViewCell) {
        if let destinationTile = to.tile {
            if let _ = tiles.index(of: tile) {
                destinationTile.character = tile.character
                tile.character = Character(" ")
            }
        }
    }
    
    func remove(tile: Tile) {
        if let index = tiles.index(of: tile) {
            tiles.remove(at: index)
        }
    }
    
}
