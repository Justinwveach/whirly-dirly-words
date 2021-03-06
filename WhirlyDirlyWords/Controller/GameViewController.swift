//
//  GameViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import CocoaLumberjack

class GameViewController: UIViewController, GameDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DraggableDelegate {
    
    @IBOutlet weak var letterCollectionView: UICollectionView!
    @IBOutlet weak var puzzleCollectionView: UICollectionView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var roundScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    weak var homeViewController: ViewController?
    
    var level: Level!
    let levelStore = LevelStore()
    let bonusStore = BonusStore()
    
    let generator = CrosswordGenerator(words: Words.sharedInstance)
    let margin: CGFloat = 2.0
    var game: Game!
    var selectedTile: TileView?

    var puzzle: CrosswordPuzzle!
    var userPuzzle: CrosswordPuzzle!
    
    var isResuming = false
    
    var puzzleDataSource: PuzzleDataSource!
    var letterDataSource: LetterDataSource!
    
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
        puzzleCollectionView.delegate = self
        
        startNewPuzzle()
    }
    
    @IBAction func refreshPuzzle(_ sender: Any) {
        startNewPuzzle()
    }
    
    @IBAction func goHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validatePuzzle(_ sender: Any) {
        let isValid = userPuzzle.validateBoard()
        
        if isValid {
            let score = ScoreKeeper.getScore(puzzle: userPuzzle)
            if score > level.highScore {
                levelStore.update(id: level.id, fields: ["highScore": score])
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let roundOverViewController = storyboard.instantiateViewController(withIdentifier: "RoundOverViewController") as! RoundOverViewController
            
            roundOverViewController.homeAction = {
                self.dismiss(animated: true, completion: nil)
            }
            
            roundOverViewController.retryAction = {
                self.startNewPuzzle()
            }
            
            roundOverViewController.nextAction = {
                // Since this is a bonus round, the next level will always be the first level for this round
                if let nextLevel = self.levelStore.levels.filter("section == %d && roundInSection == %d", self.level.section, self.level.roundInSection + 1).first {
                    // root.startLevel(section: self.bonus.section, level: 0)
                    self.level = nextLevel
                    self.startNewPuzzle()
                }
                else if let nextBonus = self.bonusStore.bonuses.filter("section == %d", self.level.section + 1).first, let root = self.homeViewController {
                    self.dismiss(animated: true) {
                        root.startBonus(section: nextBonus.section)
                    }
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            self.present(roundOverViewController, animated: false, completion: nil)
        } else {
            // Shake the board or something
        }
        
    }
    
    fileprivate func startNewPuzzle() {
        puzzle = generator.createPuzzle(wordStructure: level.wordLengths, size: level.puzzleSize)
        puzzle?.printResult()
        
        userPuzzle = CrosswordPuzzle(size: level.puzzleSize)
        for t in (puzzle?.tiles)! {
            let tile = Tile(letter: " ", column: t.column, row: t.row)
            userPuzzle.add(tile)
        }
        
        //puzzle.letters shuffles the letters for us, so let's keep that order once we shuffle
        let letters = puzzle?.letters ?? []
        letterDataSource = LetterDataSource(letters: letters, parent: self)
        puzzleDataSource = PuzzleDataSource(size: level.puzzleSize, puzzle: userPuzzle, parent: self)
        
        letterCollectionView.dataSource = letterDataSource
        puzzleCollectionView.dataSource = puzzleDataSource
        
        provideFreebies()
        
        letterCollectionView.reloadData()
        puzzleCollectionView.reloadData()
    }
    
    fileprivate func provideFreebies() {
        let randomTiles = puzzle.findRandomTiles(amount: level.lettersGiven)
        for tile in randomTiles {
            let userTile = userPuzzle.getTile(column: tile.column, row: tile.row)
            if !userTile.invalid {
                userTile.character = tile.character
                userTile.isFreebie = true
                letterDataSource.remove(letter: tile.character)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == puzzleCollectionView {
            let cell = puzzleCollectionView.cellForItem(at: indexPath) as! PuzzleCollectionViewCell
            if !cell.tile.isPlaceholder && !cell.tile.isEmpty && !cell.tile.isFreebie {
                letterDataSource.letters.append(cell.tile.character)
                cell.tile.character = Character(" ")
                puzzleCollectionView.reloadData()
                letterCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == puzzleCollectionView {
            let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(level.puzzleSize - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(level.puzzleSize)).rounded(.down)
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            return CGSize(width: 40, height: 40)
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
    
    // MARK: Draggable Delegate

    func didStartDragging(view: UIView, point: CGPoint) {
        if let superParentView = view.superview?.superview {
            if view.tag == 1 {
                letterCollectionView.bringSubview(toFront: superParentView)
            } else {
                puzzleCollectionView.bringSubview(toFront: superParentView)
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            //view.backgroundColor = UIColor(red: (63.0/255.0), green: (153.0/255.0), blue: (112.0/255.0), alpha: 0.9)
            //tileView.letterLabel.textColor = .white
            if let tileView = view as? TileView {
                tileView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                tileView.backgroundColor = Constants.primaryColor
                tileView.letterLabel.textColor = .white
            }
            
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
                            remove(tileView: tile, target: tileCell.superview?.convert(tileCell.center, to: view.superview), destination: tileCell) {
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
            
            if let tileView = tile as? TileView {
                tileView.resetUI()
            }
        }, completion: nil)
    }
    
    fileprivate func remove(tileView: TileView, target: CGPoint?, destination: TileCollectionViewCell, finished: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
                tileView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                if target != nil {
                    tileView.center = target!
                }
            }, completion: { _ in
                self.moveTileBack(tileView, animated: false)
                if let cell = tileView.cell {
                    if tileView.tag == 1 {
                        if let indexPath = self.letterCollectionView.indexPath(for: cell) {
                            self.letterDataSource.removeLetter(index: indexPath.row)
                            self.letterCollectionView.reloadData()
                        }
                    } else {
                        self.puzzleDataSource.move(tile: cell.tile, to: destination)
                        self.puzzleCollectionView.reloadData()
                    }
                }
                finished()
        })
    }
}
