//
//  CustomButton.swift
//  Talaris
//
//  Created by Taha Baig on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? self.backgroundColor?.withAlphaComponent(0.5) : self.backgroundColor?.withAlphaComponent(1.0)
        }
    }

}
