//
//  Stack.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 12/22/17.
//  Copyright © 2017 justinveach. All rights reserved.
//

import Foundation

class Stack<Element> {
    
    fileprivate var array: [Element] = []
    
    func push(_ element: Element) {
        array.append(element)
    }
    
    func pop() -> Element? {
        return array.popLast()
    }
    
    func peek() -> Element? {
        return array.last
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
}
