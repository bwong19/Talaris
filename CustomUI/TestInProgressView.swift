//
//  TestInProgressView.swift
//  Talaris
//
//  Created by Taha Baig on 5/4/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

//View displayed to user as they perform a Gait Test
class TestInProgressView : UIView {
    let timeLabel : UILabel
    let activityIndicatorView : NVActivityIndicatorView
    
    //optional data label provided for use in debugging e.g. displaying current azimuth angle as test is being performed
    var includeDataLabel : Bool = false
    var dataLabel : UILabel?
    
    init(includeDataLabel: Bool = false) {
        timeLabel = UILabel()
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 250, height: 250), type: .ballScaleRippleMultiple, color: UIColor(red:0.54, green:0.84, blue:0.98, alpha:1.0))
        
        super.init(frame: CGRect.zero)
        self.includeDataLabel = includeDataLabel
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        layoutView()
    }
    
    private func setupView() {
        timeLabel.text = "0.0s"
        //self.timeLabel.font = timeLabel.font.withSize(72)
        timeLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 72)
        timeLabel.textColor = UIColor(red:0.54, green:0.84, blue:0.98, alpha:1.0)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints  = false
        addSubview(activityIndicatorView)
        
        if (includeDataLabel) {
            dataLabel = UILabel()
            dataLabel!.text = "Default Data Label"
            dataLabel!.textColor = UIColor(red:0.54, green:0.84, blue:0.98, alpha:1.0)
            dataLabel!.font = timeLabel.font.withSize(36)
            dataLabel!.adjustsFontSizeToFitWidth = true
            dataLabel!.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutView() {
        backgroundColor = UIColor(red:0.00, green:0.19, blue:0.25, alpha:1.0)
        
        activityIndicatorView.widthAnchor.constraint(equalToConstant: frame.width/2).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: frame.width/2).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: frame.height / 6).isActive = true
        
        if (includeDataLabel) {
            addSubview(dataLabel!)
            dataLabel!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            dataLabel!.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -20).isActive = true
        }
    }
    
}
