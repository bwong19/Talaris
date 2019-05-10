//
//  GaitTestViewController.swift
//  Talaris
//
//  Created by Taha Baig on 5/9/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit

// general purpose superclass that individual gait tests can inherit from, essentially similar to an abstract class
class GaitTestViewController: UIViewController {
    let motionTracker: MotionTracker
    let testInProgressView : TestInProgressView
    
    let TIME_INTERVAL = 0.1
    var timer : Timer!
    var counter: Double!
    
    init(samplingRate: Double, includeDataLabel: Bool = false) {
        motionTracker = MotionTracker(samplingRate: samplingRate)
        testInProgressView = TestInProgressView(includeDataLabel: includeDataLabel)
        counter = 0.0
        
        super.init(nibName: nil, bundle: nil)
        setupMotionTracker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // although empty in the superclass, this is more useful for overriding subclasses
    func setupMotionTracker() {}
    
    override func loadView() {
        view = testInProgressView
    }
    
    func startTest() {
        testInProgressView.activityIndicatorView.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: TIME_INTERVAL, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        motionTracker.startRecording()
    }
    
    func stopTest() {
        timer.invalidate()
        motionTracker.stopRecording()
    }
    
    @objc func updateTimer() {
        counter += TIME_INTERVAL
        testInProgressView.timeLabel.text = String(format: "%.1fs", counter)
    }
    
}
