//
//  FoundWordsView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/19/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class FoundWordsView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var remainingWordsLabel: UILabel!
    @IBOutlet weak var wordsFoundLabel: UILabel!
    
    @IBInspectable var sectionTitle: String = ""
    
    var totalWords = 0 {
        didSet {
            remainingWordsLabel.text = "\(totalWords)"
        }
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.text = sectionTitle
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("FoundWordsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        wordsFoundLabel.text = ""
    }
    
    func add(word: String) {
        if !wordsFoundLabel.text!.isEmpty {
            wordsFoundLabel.text!.append(", ")
        }
        wordsFoundLabel.text!.append(word)
        totalWords = totalWords - 1
    }
    
    func addMissing(word: String) {
        var missingWord = ""
        if !wordsFoundLabel.text!.isEmpty {
            missingWord.append(", ")
        }
        missingWord.append(word)
        
        var startRange = 0
        if wordsFoundLabel.text!.count > 0 {
            startRange = wordsFoundLabel.text!.count
        }
        let range: NSRange = NSRange(location: startRange, length: missingWord.count)
        
        let attributedString = NSMutableAttributedString(string: missingWord, attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])

       // let attributedString: NSMutableAttributedString = wordsFoundLabel.attributedText?.mutableCopy() as! NSMutableAttributedString// NSMutableAttributedString(string: wordsFoundLabel.text!, attributes: [:])
        //attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
        let currentAttributedString: NSMutableAttributedString = wordsFoundLabel.attributedText?.mutableCopy() as! NSMutableAttributedString
        currentAttributedString.append(attributedString)
        wordsFoundLabel.attributedText = currentAttributedString
    }
    
    func incrementWordCount() {
        totalWords = totalWords + 1
    }
    
    func reset() {
        totalWords = 0
        wordsFoundLabel.text = ""
    }
}
