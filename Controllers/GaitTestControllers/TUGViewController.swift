//
//  TUGViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

// Timed Up and Go Gait Test
class TUGViewController: GaitTestViewController {
    private let SAMPLING_RATE = 10.0
    private let STANDING_THRESHOLD = 1.0
    private let SITTING_THRESHOLD = 0.4

    private var sit2stand: Double!
    private var stand2sit: Double!
    
    private var hasStoodUp: Bool!
    private var walking: Bool!
    
    init() {
        sit2stand = 0.0
        stand2sit = 0.0
        
        hasStoodUp = false
        walking = false
        
        super.init(samplingRate: SAMPLING_RATE, includeDataLabel: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func setupMotionTracker() {
        motionTracker.handleAttitudeUpdate { attitude in
            if ((attitude.pitch >= self.STANDING_THRESHOLD || attitude.pitch <= -self.STANDING_THRESHOLD) && self.hasStoodUp == false) {
                self.sit2stand = self.counter
                self.hasStoodUp = true
                self.walking = true
            }
            
            
            if (attitude.pitch >= -self.SITTING_THRESHOLD && attitude.pitch <= self.SITTING_THRESHOLD && self.hasStoodUp) {
                self.stopTest()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        PhoneVoice.speak(speech: "Place the phone in your pocket")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.startTest()
        })
        
    }
    
    override func startTest() {
        super.startTest()
        PhoneVoice.speak(speech: "Start walking")
    }
    
    override func stopTest() {
        super.stopTest()
        PhoneVoice.speak(speech: "Good Work!")
        
        let resultsDict  = ["tug_time" : counter, "sit_to_stand_time" : sit2stand]
        let cv = CheckViewController(message: String(format: "Your TUG time was %.1lf seconds. Your sit-to-stand duration is %.1lf seconds", counter, sit2stand), resultsDict : resultsDict as Dictionary<String, Any>, motionTracker:self.motionTracker, testType: "TUG")
        self.navigationController!.pushViewController(cv, animated: true)
    }

}
