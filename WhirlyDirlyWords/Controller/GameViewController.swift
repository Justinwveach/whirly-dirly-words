//
//  GameViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit
import CocoaLumberjack

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var letterCollectionView: UICollectionView!
    @IBOutlet weak var puzzleCollectionView: UICollectionView!
    @IBOutlet weak var allLettersStackView: UIStackView!
    
    var round: Int = 1
    let generator = CrosswordGenerator(words: Words.sharedInstance)
    let puzzleSize = 8
    let margin: CGFloat = 2.0

    var puzzle: CrosswordPuzzle?
    var letters: [Character] = []
    
    var isResuming = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let flowLayout = puzzleCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
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
        //puzzle.letters shuffles the letters for us, so let's keep that order once we shuffle
        letters = puzzle?.letters ?? []
        populateCompleteView(letters: letters)
        
        letterCollectionView.reloadData()
        puzzleCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == letterCollectionView {
            return puzzle?.letters.count ?? 0
        } else {
            return puzzleSize * puzzleSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == letterCollectionView {
            let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCollectionViewCell", for: indexPath) as! LetterCollectionViewCell
            cell.letterLabel.text = String(letters[indexPath.row])
            return cell
        } else {
            let cell: PuzzleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzleCollectionViewCell", for: indexPath) as! PuzzleCollectionViewCell
           
            let size = puzzleSize
            let column = indexPath.row < size ? indexPath.row : indexPath.row % size
            let row = indexPath.row / size
            
            let tile = puzzle?.getTile(column: column, row: row)
            cell.letterLabel.text = tile?.letter
            
            if (tile?.isEmpty)! {
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
            return CGSize(width: 45, height: 45)
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
}
