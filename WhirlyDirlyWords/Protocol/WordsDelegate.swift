//
//  ParserDelegate.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import Foundation

protocol WordsDelegate {
    func finishedParsing(words: [String])
    func finishedPopulating()
}
