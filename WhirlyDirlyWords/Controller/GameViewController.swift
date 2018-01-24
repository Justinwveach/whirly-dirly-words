//
//  GameViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import CocoaLumberjack

class GameViewController: UIViewController, GameDelegate, TileDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DraggableDelegate {
    
    @IBOutlet weak var letterCollectionView: UICollectionView!
    @IBOutlet weak var puzzleCollectionView: UICollectionView!
    @IBOutlet weak var allLettersStackView: UIStackView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var roundScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    var round: Int = 1
    let generator = CrosswordGenerator(words: Words.sharedInstance)
    let puzzleSize = 8
    let margin: CGFloat = 2.0
    var game: Game!
    var selectedTile: TileView?

    var puzzle: CrosswordPuzzle!
    var userPuzzle: CrosswordPuzzle!
    
    var letters: [Character] = []
    
    var isResuming = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let flowLayout = puzzleCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        if isResuming {
            
        } else {
            game = Game(delegate: self, startingRound: 1)
        }
        
        letterCollectionView.delegate = self
        letterCollectionView.dataSource = self
        
        puzzleCollectionView.delegate = self
        puzzleCollectionView.dataSource = self
        
        round = 1
        
        startNewPuzzle()
    }
    
    @IBAction func refreshPuzzle(_ sender: Any) {
        startNewPuzzle()
    }
    
    fileprivate func startNewPuzzle() {
        puzzle = generator.createPuzzle(wordStructure: [.short, .medium, .long, .medium], size: puzzleSize)
        puzzle?.printResult()
        
        userPuzzle = CrosswordPuzzle(size: puzzleSize)
        for t in (puzzle?.tiles)! {
            let tile = Tile(letter: " ", column: t.column, row: t.row)
            userPuzzle.add(tile)
        }
        
        //puzzle.letters shuffles the letters for us, so let's keep that order once we shuffle
        letters = puzzle?.letters ?? []
        populateCompleteView(letters: letters)
        
        /*
        for word in puzzle.allWords {
            var chars = [Character]()
            for char in word {
                chars.append(char)
            }
            letters.append(chars)
        }
        */
        
        letterCollectionView.reloadData()
        puzzleCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == letterCollectionView {
            return letters.count
        } else {
            return puzzleSize * puzzleSize
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == letterCollectionView {
            
            let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCollectionViewCell", for: indexPath) as! LetterCollectionViewCell
            cell.tileView.letterLabel.text = String(letters[indexPath.row])
            cell.tileView.delegate = self
            cell.tileView.cell = cell
            cell.delegate = self
            return cell
        } else {
            let cell: PuzzleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCollectionViewCell", for: indexPath) as! PuzzleCollectionViewCell
           
            let size = puzzleSize
            let column = indexPath.row < size ? indexPath.row : indexPath.row % size
            let row = indexPath.row / size
            
            let tile = userPuzzle.getTile(column: column, row: row)
            cell.letterLabel.text = tile.letter
            cell.tile = tile
            
            cell.delegate = self

            if tile.isEmpty {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == puzzleCollectionView {
            let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(puzzleSize - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(puzzleSize)).rounded(.down)
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            return CGSize(width: 40, height: 40)
        }
    }
    
    fileprivate func populateCompleteView(letters: [Character]) {
        //let width = allLettersStackView.frame.size.width / CGFloat(letters.count)
        //let height = allLettersStackView.frame.size.height
        
        for label in allLettersStackView.subviews {
            label.removeFromSuperview()
        }
        
        for letter in letters {
           // let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
            let label = UILabel()
            label.text = String(letter)
            label.font = UIFont(name: "Futura Bold", size: 10.0)
            label.textColor = UIColor.darkGray
            label.adjustsFontSizeToFitWidth = false
            label.textAlignment = .center
            allLettersStackView.addArrangedSubview(label)
        }
    }
    
    // MARK: Game Delegate
    
    func updated(totalScore: Int) {
        totalScoreLabel.text = "\(totalScore)"
    }
    
    func updated(roundScore: Int) {
        roundScoreLabel.text = "\(roundScore)"
    }
    
    func updated(round: Int) {
        roundLabel.text = "\(round)"
    }
    
    // MARK: Tile Delegate
    
    func longPressed(cell: TileCollectionViewCell) {
        if let point = cell.superview?.convert(cell.center, to: view) {
            
        }
        /*
        if selectedTile == nil {
            let tileView = TileView.instanceFromNib()
            if let point = cell.superview?.convert(cell.center, to: view) {
                tileView.frame = CGRect(x: point.x, y: point.y, width: 40, height: 50)
                tileView.delegate = self
                self.view.addSubview(tileView)
            }
            selectedTile = tileView
        }
         */
    }
    
    // MARK: Draggable Delegate

    func didStartDragging(view: UIView, point: CGPoint) {
        UIView.animate(withDuration: 0.2) {
            view.backgroundColor = .white
            view.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
    }
    
    func didStopMoving(view: UIView, point: CGPoint) {
        if let tile: TileView = view as? TileView {
            guard let point = view.superview?.convert(view.center, to: puzzleCollectionView) else {
                return
            }
            
            for cell in puzzleCollectionView.visibleCells {
                guard let tileCell = cell as? PuzzleCollectionViewCell else {
                    return
                }
    
                if tileCell.frame.contains(point) {
                    if let cellTile = tileCell.tile {
                        if cellTile.isPlaceholder && tile.letterLabel != nil && !tile.letterLabel.text!.isEmpty {
                            remove(tileView: tile, target: tileCell.superview?.convert(tileCell.center, to: view.superview)) {
                                tileCell.tile.character = Character(tile.letterLabel.text ?? " ")
                                self.puzzleCollectionView.reloadData()
                            }
                            return
                        }
                    }
                }
            }
            moveTileBack(tile, animated: true)
        }
    }
    
    func viewWasDragged(view: UIView, point: CGPoint) {
        //DDLogDebug("Dragged")
    }
    
    fileprivate func moveTileBack(_ tile: DraggableView, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.2 : 0.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            tile.center = tile.originalPoint!
            tile.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    fileprivate func remove(tileView: TileView, target: CGPoint?, finished: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
                tileView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                if target != nil {
                    tileView.center = target!
                }
            }, completion: { _ in
                self.moveTileBack(tileView, animated: false)
                if let cell = tileView.cell {
                    if let indexPath = self.letterCollectionView.indexPath(for: cell) {
                        self.letters.remove(at: indexPath.row)
                        self.letterCollectionView.reloadData()
                    }
                }
                finished()
        })
    }
}
