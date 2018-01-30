//
//  DraggableView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 1/23/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit
import CocoaLumberjack

class DraggableView: UIView, UIGestureRecognizerDelegate {
    
    var parentView: UIView! = nil
    var delegate: DraggableDelegate?
    
    var draggedPoint: CGPoint = CGPoint.zero
    var originalPoint: CGPoint?
    var panGesture: UIPanGestureRecognizer?
    
    // todo: provide way to set offset
    var offset: CGFloat = 50.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        offset = self.frame.size.height + 20
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        offset = self.frame.size.height + 20
    }

    override func didMoveToSuperview() {
        if superview != nil {
            draggedPoint = center
            addGesture()
        } else {
            removeGesture()
        }
    }
    
    fileprivate func addGesture()  {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.name = "pan"
        self.addGestureRecognizer(panGesture)
        
       // let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        //self.addGestureRecognizer(longPress)
    }
    
    fileprivate func removeGesture() {
        if panGesture != nil {
            self.removeGestureRecognizer(panGesture!)
        }
    }
    
    @objc fileprivate func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        if !isDraggable() {
            return
        }
        
        let translation = panGesture.translation(in: parentView)
        
        if panGesture.state == UIGestureRecognizerState.began {
            originalPoint = center// CGPoint(x: self.draggedPoint.x + translation.x, y: self.draggedPoint.y + translation.y)
            UIView.animate(withDuration: 0.2) {
                self.center = CGPoint(x: self.center.x, y: self.center.y - self.offset)
            }
            delegate?.didStartDragging(view: self, point: center)
        }
        else if panGesture.state == UIGestureRecognizerState.ended {
            delegate?.didStopMoving(view: self, point: center)
        }
        else if panGesture.state == UIGestureRecognizerState.changed {
            center = CGPoint(x: self.draggedPoint.x + translation.x, y: self.draggedPoint.y + translation.y - offset)
            delegate?.viewWasDragged(view: self, point: center)
        }
        else {
            // or something when its not moving
        }
    }
    
    func isDraggable() -> Bool {
        return true
    }
    
    /*
    @objc fileprivate func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        isDraggable = true
    }
    */
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
