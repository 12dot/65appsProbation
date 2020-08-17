//
//  XibView.swift
//  first
//
//  Created by 12dot on 17.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

@IBDesignable class XibView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var nibView : UIView!
    let nibName = "XibView"
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        print("infinite loop")
        super.init(coder: aDecoder)
        setup()
    }



    func setup() {
        nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth ,UIView.AutoresizingMask.flexibleHeight]
        addSubview(nibView)
    }

    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

}
