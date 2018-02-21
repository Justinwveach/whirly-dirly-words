//
//  BonusRoundViewController.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit
import CocoaLumberjack

class BonusRoundViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TimerDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var letterCollectionView: UICollectionView!
    @IBOutlet weak var currentWordView: WordView!

    @IBOutlet weak var threeLetterWordsView: FoundWordsView!
    @IBOutlet weak var fourLetterWordsView: FoundWordsView!
    @IBOutlet weak var fiveLetterWordsView: FoundWordsView!
    @IBOutlet weak var sixLetterWordsView: FoundWordsView!
    
    var bonusStore = BonusStore()
   
    var baseWord = ""
    
    var letters = [Character]()
    var allWords = [String]()
    var foundWords = [String]()
    var round: Int = 1
    var currentWord: Word!
    let wordLength = 6
    let roundLength: Double = 20
    var score: Int = 0 {
        didSet {
            navItem.title = "\(score)"
        }
    }
    var bonus: Bonus!
    
    var navBarTimerView: TimerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarTimerView = TimerView.instanceFromNib() as! TimerView
        let timerButton = UIBarButtonItem(customView: navBarTimerView)
        
        navItem.rightBarButtonItems = [timerButton]
        
        letterCollectionView.delegate = self
        letterCollectionView.dataSource = self
        
        let margin: CGFloat = 2.0
        guard let flowLayout = letterCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        setupNewRound()
    }
    
    // MARK: Actions
    
    @IBAction func checkWord(_ sender: Any) {
        if !foundWords.contains(currentWord.value) {
            for word in allWords {
                if word == currentWord.value {
                    incrementMultilplier(word: word)
                    foundWords.append(currentWord.value)
                    getSection(lengthOfWord: currentWord.count).add(word: currentWord.value)
                    break
                }
            }
        }
        
        resetLetters()
    }
    
    @IBAction func resetLetters(_ sender: Any) {
        resetLetters()
    }
    
    @IBAction func showMoreOptions(_ sender: Any) {
        let alert = UIAlertController(title: "Options", message: "If you are in the middle of a round, you will lose current progress if you restart or leave.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        let goHomeAction = UIAlertAction(title: "Go To Home Screen", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let restartRound = UIAlertAction(title: "Restart Round", style: .default) { _ in
            self.setupNewRound()
            self.startNewRound()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(goHomeAction)
        alert.addAction(restartRound)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Collection View
    
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
    
    // MARK: Timer Delegate
    
    func exceededTimeLimit() {
        navBarTimerView.timerLabel.invalidate()
        endRound()
    }
    
    // MARK: Private Methods
    
    fileprivate func setupNewRound() {
        resetSections()
        
        allWords.removeAll()
        // Make sure the word contains enough permutations
        while allWords.count < 12 {
            baseWord = Words.sharedInstance.getRareWord(exactLength: wordLength)
            allWords = Words.sharedInstance.getWordsContaining(letters: baseWord)
        }
        
        if currentWord != nil {
            currentWord.popAll()
        }
        
        currentWord = Word(delegate: currentWordView)
        currentWordView.setup(word: currentWord, maxLetters: wordLength)
        
        shuffleLetters()

        for word in allWords {
            getSection(lengthOfWord: word.count).incrementWordCount()
        }
    }
    
    fileprivate func startNewRound() {
        score = 0
        
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.second]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.zeroFormattingBehavior = .pad
        dateComponentsFormatter.unitsStyle = .positional
        
        navBarTimerView.timerLabel.countdown(endDate: Date().addingTimeInterval(roundLength), interval: .second, formatter: dateComponentsFormatter)
        navBarTimerView.timerLabel.delegate = self
    }
    
    fileprivate func endRound() {
        currentWord.popAll()
        
        for word in allWords {
            if foundWords.contains(word) {
                
            } else {
                getSection(lengthOfWord: word.count).addMissing(word: word)
            }
        }
        
        baseWord = ""
        letters.removeAll()
        letterCollectionView.reloadData()

        //if multiplier > levelMultiplier.value {
        bonusStore.update(id: bonus.id, fields: ["value": score])
        //}
    }
    
    fileprivate func incrementMultilplier(word: String) {
        let increment = ScoreKeeper.getBonusIncrement(word)
        score = score + increment
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
    
    fileprivate func resetSections() {
        threeLetterWordsView.reset()
        fourLetterWordsView.reset()
        fiveLetterWordsView.reset()
        sixLetterWordsView.reset()
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
}
