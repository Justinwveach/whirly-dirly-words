//
//  File.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/23/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

public protocol DraggableDelegate {
    func didStartDragging(view: UIView, point: CGPoint)
    func didStopMoving(view: UIView, point: CGPoint)
    func viewWasDragged(view: UIView, point: CGPoint)
}
