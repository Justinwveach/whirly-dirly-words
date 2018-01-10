//
//  WordView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit

class WordView: UIView, WordDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var wordCollectionView: UICollectionView!
    
    var word: Word!
    var actualWord: String!
    
    /*
    override init (frame : CGRect) {
        super.init(frame : frame)
        // Do what you want.
        word = Word(delegate: self)
    }
    
    override init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    */
    
    class func instanceFromNib() -> WordView {
        let wordView: WordView = UINib(nibName: "WordView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WordView
        //wordView.wordCollectionView.register(LetterCell.self, forCellWithReuseIdentifier: "LetterCell")
        wordView.wordCollectionView.register(UINib(nibName: "LetterCell", bundle: nil), forCellWithReuseIdentifier: "LetterCell")
        
        return wordView
    }
    
    public func setup(word: Word, actualWord: String) {
        self.word = word
        self.actualWord = actualWord
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
    }
    
    func pushed(letter: Character) {
        wordCollectionView.reloadData()
    }
    
    func popped(letter: Character) {
        wordCollectionView.reloadData()
    }
    
    // MARK: CollectionView Delegate/DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return word.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCell
        
        cell.letterLabel.text = String(word.get(indexPath.row))
        return cell
    }
    
}
