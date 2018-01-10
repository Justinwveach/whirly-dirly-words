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
    var currentWord: Word?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterCollectionView.delegate = self
        letterCollectionView.dataSource = self
        
        round = 1
        
        let wordValues = Parser.parseWords(file: "words-extended", type: "txt")
        words = Words(allWords: wordValues)
        
        startNewWord()
        addWordView()
        currentWord?.push("w")
        currentWord?.push("o")
        currentWord?.push("r")
        currentWord?.push("d")
    }
    
    fileprivate func startNewWord() {
        letters.append("A")
        letters.append("Z")
        letters.append("E")
        letters.append("A")
        letters.append("Z")
        letters.append("E")
        letters.append("A")
        letters.append("Z")
        letters.append("E")
        
        letterCollectionView.reloadData()
    }
    
    fileprivate func addWordView() {
        let wordView = WordView.instanceFromNib()
        wordView.frame = CGRect(x: 0, y: 300, width: 350, height: 80)
        let word = Word(delegate: wordView)
        currentWord = word
        wordView.setup(word: word, actualWord: "word")
        
        view.addSubview(wordView)
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
