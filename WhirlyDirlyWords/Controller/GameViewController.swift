//
//  GameViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var letterCollectionView: UICollectionView!
    
    var words: Words!
    
    var letters: [String] = []
    var round: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterCollectionView.delegate = self
        letterCollectionView.dataSource = self
        
        round = 1
        
        let wordValues = Parser.parseWords(file: "words-extended", type: "txt")
        words = Words(allWords: wordValues)
        
        startNewWord()
    }
    
    fileprivate func startNewWord() {
        letters.append("A")
        letters.append("Z")
        letters.append("E")
        
        letterCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCollectionViewCell", for: indexPath) as! LetterCollectionViewCell
        cell.letterLabel.text = letters[indexPath.row]
        return cell
    }
}
