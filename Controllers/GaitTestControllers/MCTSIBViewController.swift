//
//  TUGViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import FirebaseDatabase

//Performs a single 30 second version of MCTSIB test
//TODO: If it is decided to make a version involving 4 MCTSIB tests, build a wrapper around this that creates it 4 times with new command for each
class MCTSIBViewController: GaitTestViewController, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private let soundCode = 1005

    private static let DEFAULT_COMMAND = "Place the phone at the center of your waist, Stand while keeping your eyes open, Hold the position, test starting in 5 seconds."
    private let SAMPLING_RATE = 10.0
    
    private let SVM_THRESH = 2.0
    private let SVM_DELTA = 0.15
    private let TEST_DURATION = 30.0 // in seconds

    private var finalTime: Double!
    private var command: String!
    
    public init(command: String = DEFAULT_COMMAND) {
        self.command = command
        super.init(samplingRate: SAMPLING_RATE, includeDataLabel: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func setupMotionTracker() {
        motionTracker.handleAccelerationUpdate { accelerometerData in
            let SVM = (pow(accelerometerData.acceleration.x,2) + pow(accelerometerData.acceleration.y,2) + pow(accelerometerData.acceleration.z,2)).squareRoot()
            DispatchQueue.main.async {
                self.testInProgressView.dataLabel?.text = "\(SVM)"
            }
            if ((SVM > 1.0 + self.SVM_DELTA || SVM < 1.0 - self.SVM_DELTA) || self.counter >= 30) {
                self.finalTime = min(30.0, self.counter)
                self.stopTest()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        synthesizer.delegate = self
        UIApplication.shared.isIdleTimerDisabled = true
        
        navigationItem.hidesBackButton = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.startTest()
        })
        
    }
    
    override func startTest() {
        let utterance = AVSpeechUtterance(string: command)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    override func stopTest() {
        super.stopTest()
        
        PhoneVoice.speak(speech: "Good work!")
        
        let score = finalTime!
        let resultsDict  : [String : Any] = ["score" : score, "max_score" : 30]

        self.navigationController!.pushViewController(CheckViewController(message: String(format: "Your score is %.1lf/30", score), resultsDict: resultsDict, motionTracker:self.motionTracker, testType: "MCTSIB"), animated: true)        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
            super.startTest()
        }
    }
    
}
