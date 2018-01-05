//
//  File.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation

protocol WordDelegate {
    func pushed(letter: Character)
    func popped(letter: Character)
}
