//
//  BonusRoundViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit
import CocoaLumberjack

class BonusRoundViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var letterCollectionView: UICollectionView!
    @IBOutlet weak var currentWordView: WordView!
    
    @IBOutlet weak var threeLetterWordsView: FoundWordsView!
    @IBOutlet weak var fourLetterWordsView: FoundWordsView!
    @IBOutlet weak var fiveLetterWordsView: FoundWordsView!
    @IBOutlet weak var sixLetterWordsView: FoundWordsView!
   
    var baseWord = ""
    
    var letters = [Character]()
    var allWords = [String]()
    var foundWords = [String]()
    var round: Int = 1
    var currentWord: Word!
    let wordLength = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseWord = Words.sharedInstance.getWord(exactLength: wordLength)

        letterCollectionView.delegate = self
        letterCollectionView.dataSource = self
        
        let margin: CGFloat = 2.0
        guard let flowLayout = letterCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        shuffleLetters()
        
        allWords = Words.sharedInstance.getWordsContaining(letters: baseWord)
        
        currentWord = Word(delegate: currentWordView)
        currentWordView.setup(word: currentWord, maxLetters: wordLength)
        
        for word in allWords {
            getSection(lengthOfWord: word.count).incrementWordCount()
        }
    }
    
    @IBAction func checkWord(_ sender: Any) {
        if foundWords.contains(currentWord.value) {
            return
        }
        
        for word in allWords {
            if word == currentWord.value {
                foundWords.append(currentWord.value)
                getSection(lengthOfWord: currentWord.count).add(word: currentWord.value)
                break
            }
        }
        
        resetLetters()
    }
    
    @IBAction func resetLetters(_ sender: Any) {
        resetLetters()
    }
    
    fileprivate func resetLetters() {
        currentWord.popAll()
        shuffleLetters()
    }
    
    fileprivate func shuffleLetters() {
        letters.removeAll()
        for letter in baseWord.jumble {
            letters.append(letter)
        }
        letterCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCollectionViewCell", for: indexPath) as! LetterCollectionViewCell
        cell.letterLabel.text = String(letters[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let letter = letters[indexPath.row]
        if letter == Character(" ") {
            return
        }
        
        currentWord.push(letter)
        
        letters[indexPath.row] = Character(" ")
        letterCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = getCellSize(collectionView: collectionView)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    fileprivate func getCellSize(collectionView: UICollectionView) -> CGFloat {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(wordLength - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(wordLength)).rounded(.down)
        return itemWidth
    }
    
    fileprivate func getSection(lengthOfWord: Int) -> FoundWordsView {
        switch lengthOfWord {
        case 3:
            return threeLetterWordsView
        case 4:
            return fourLetterWordsView
        case 5:
            return fiveLetterWordsView
        default:
            return sixLetterWordsView
        }
    }
}
