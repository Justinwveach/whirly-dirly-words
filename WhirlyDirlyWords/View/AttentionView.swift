//
//  AttentionView.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/21/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit

class AttentionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var xConstraint: NSLayoutConstraint!
    var shouldAnimate = false
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("AttentionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instanceFromNib() -> AttentionView {
        let view = UINib(nibName: "AttentionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AttentionView
        view.addSubview(view.contentView)
        view.contentView.frame = view.bounds
        return view
    }
    
    func startAnimation(viewToLayout: UIView) {
        self.xConstraint.constant = -10
        viewToLayout.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.xConstraint.constant = self.xConstraint.constant + 20
            viewToLayout.layoutIfNeeded()
        }, completion: nil)
    }

}
