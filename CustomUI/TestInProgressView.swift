//
//  TestInProgressView.swift
//  Talaris
//
//  Created by Taha Baig on 5/4/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TestInProgressView : UIView {
    var timeLabel : UILabel!
    var activityIndicatorView : NVActivityIndicatorView!
    var includeDataLabel : Bool = false
    var dataLabel : UILabel?
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.createView()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    init(includeDataLabel : Bool = false) {
        super.init(frame: CGRect.zero)
        self.includeDataLabel = includeDataLabel
        self.createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.layoutView()
    }
    
    private func createView() {
        self.timeLabel = UILabel()
        self.timeLabel.text = "0.0s"
        //self.timeLabel.font = timeLabel.font.withSize(72)
        self.timeLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 72)
        self.timeLabel.textColor = UIColor(red:0.54, green:0.84, blue:0.98, alpha:1.0)
        self.timeLabel.adjustsFontSizeToFitWidth = true
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.timeLabel)
        
        let frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .ballScaleRippleMultiple, color: UIColor(red:0.54, green:0.84, blue:0.98, alpha:1.0))
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints  = false
        self.addSubview(activityIndicatorView)
        
        if (includeDataLabel) {
            self.dataLabel = UILabel()
            self.dataLabel!.text = "Default Data Label"
            self.dataLabel!.textColor = UIColor(red:0.54, green:0.84, blue:0.98, alpha:1.0)
            self.dataLabel!.font = timeLabel.font.withSize(36)
            self.dataLabel!.adjustsFontSizeToFitWidth = true
            self.dataLabel!.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutView() {
        self.backgroundColor = UIColor(red:0.00, green:0.19, blue:0.25, alpha:1.0)
        
        activityIndicatorView.widthAnchor.constraint(equalToConstant: self.frame.width/2).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: self.frame.width/2).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        self.timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.timeLabel.topAnchor.constraint(equalTo: self.activityIndicatorView!.bottomAnchor, constant: self.frame.height / 6).isActive = true
        
        if (includeDataLabel) {
            self.addSubview(self.dataLabel!)
            self.dataLabel!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.dataLabel!.bottomAnchor.constraint(equalTo: self.timeLabel.topAnchor, constant: -20).isActive = true
        }
    }
    
}
