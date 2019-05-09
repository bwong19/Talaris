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

class MCTSIBViewController: UIViewController, AVSpeechSynthesizerDelegate {
    var timer = Timer()
    var counter = 0.0
    var ref : DatabaseReference!
    let synthesizer = AVSpeechSynthesizer()

    let motionTracker : MotionTracker = MotionTracker(samplingRate: 10.0)

    let motionManager = CMMotionManager()
    let SVM_thresh = 2.0
    let DSVM_thresh = 6.0
    var timelist = [Double]()
    
    var commands = [String]()
    
    let testDuration = 30.0 // in seconds
    
    var motionTimer = Timer()
    
    let soundCode = 1005
    
    let sampling_rate = 10.0
    var curAzimuth = -1.0
    var azimuthData : [Double] = []
    let threshold = 100.0
    
    var ax_prev = 1.0
    var ay_prev = 1.0
    var az_prev = 1.0
    var test_num = 0
    
    var testInProgressView : TestInProgressView!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        var commandList = [String]()
        commandList.append("Place the phone at the center of your waist, Stand while keeping your eyes open, Hold the position, test starting in 5 seconds.")
        commandList.append("Now close your eyes and stay standing on the same firm surface, test starting in 5 seconds.")
        commandList.append("Now switch to a foam surface. Open your eyes and hold your position. Test starting in 5 seconds.")
        commandList.append("Finally, close your eyes and stay standing on the same foam surface, test starting in 5 seconds.")
        
        self.commands = commandList
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func loadView() {
        testInProgressView = TestInProgressView(includeDataLabel: false)
        view = testInProgressView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Database.database().reference()
        synthesizer.delegate = self
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.navigationItem.hidesBackButton = true
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.startTest()
        })
        
    }
    
    func startTest() {
        //AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        
        let utterance = AVSpeechUtterance(string: commands[test_num])
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.synthesizer.speak(utterance)
    }
    
    func stopTest() {
        self.motionTracker.stopRecording()
        // stop timer
        self.timer.invalidate()
        self.motionTimer.invalidate()
        
        let utterance = AVSpeechUtterance(string: "Good work!")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.synthesizer.speak(utterance)
        
        let score = self.timelist.reduce(0, +)
        let resultsDict  : [String : Any] = ["score" : score, "max_score" : 30]

        self.navigationController!.pushViewController(CheckViewController(message: String(format: "Your score is %.1lf/30", score), resultsDict: resultsDict, motionTracker:self.motionTracker, testType: "MCTSIB"), animated: true)        
    }
    
    
    @objc func updateTimer() {
        self.counter += 0.1
        self.testInProgressView.timeLabel.text = String(format: "%.1fs", counter)
    }
    
    @objc func getData() {
        print(counter)
        if let accelerometerData = motionManager.accelerometerData {
            let SVM = (pow(accelerometerData.acceleration.x,2) + pow(accelerometerData.acceleration.y,2) + pow(accelerometerData.acceleration.z,2)).squareRoot()
            DispatchQueue.main.async {
                self.testInProgressView.dataLabel?.text = "\(SVM)"
            }
            //self.timeLabel.text = String(format: "%f", SVM)
            let SVM_delta = 0.15
            if ((SVM > 1.0 + SVM_delta || SVM < 1.0 - SVM_delta) || self.counter >= 30) {
                self.motionTimer.invalidate()
                self.timer.invalidate()
                self.testInProgressView.timeLabel.text = "0.0s"
                self.timelist.append(self.counter)
                if (self.timelist.count == 1) {
                    self.stopTest()
                } else {
                    self.testInProgressView.activityIndicatorView.stopAnimating()
                    let utterance = AVSpeechUtterance(string: commands[test_num])
                    utterance.rate = 0.4
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    self.synthesizer.speak(utterance)
                }
                
            }
            
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (test_num == 1) {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Change `2.0` to the desired number
            AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
            self.testInProgressView.activityIndicatorView.startAnimating()
            self.counter = 0.0
            self.motionTracker.startRecording()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            self.motionTimer = Timer.scheduledTimer(timeInterval: 1 / self.sampling_rate, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
        }
        test_num+=1
    }
    
}
