//
//  WordView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import UIKit

class WordView: UIView, WordDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var wordCollectionView: UICollectionView!
    @IBOutlet var contentView: UIView!
    
    static let letterSize = 20
    let margin: CGFloat = 2.0

    var word: Word!
    var maxLetters = 6

    override init (frame : CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    class func instanceFromNib() -> WordView {
        let wordView: WordView = UINib(nibName: "WordView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WordView
        wordView.setupCollectionView()
        return wordView
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("WordView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        //wordView.wordCollectionView.register(LetterCell.self, forCellWithReuseIdentifier: "LetterCell")
        wordCollectionView.register(UINib(nibName: "LetterCell", bundle: nil), forCellWithReuseIdentifier: "LetterCell")
        
        guard let flowLayout = wordCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    public func setup(word: Word, maxLetters: Int) {
        self.word = word
        self.maxLetters = maxLetters
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
        let count = word.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCell
        
        cell.letterLabel.text = String(word.get(indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = getCellSize(collectionView: collectionView)
        return CGSize(width: itemWidth, height: itemWidth > maxCellHeight ? maxCellHeight : itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var height = getCellSize(collectionView: collectionView)
        if height > maxCellHeight {
            height = maxCellHeight
        }
        let inset = ((collectionView.superview?.frame.size.height)! - height) / 2
        return UIEdgeInsetsMake(inset, flowLayout.sectionInset.left, inset, flowLayout.sectionInset.right)
    }
    
    fileprivate func getCellSize(collectionView: UICollectionView) -> CGFloat {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(maxLetters - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(maxLetters)).rounded(.down)
        return itemWidth
    }
    
    var maxCellHeight: CGFloat {
        get {
            return contentView.frame.size.height - (margin * 2)
        }
    }
}
