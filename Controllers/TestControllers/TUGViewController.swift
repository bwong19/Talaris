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

class TUGViewController: UIViewController {
    var timer = Timer()
    var counter = 0.0
    var sit2stand = 0.0
    var stand2sit = 0.0
    
    let motionManager = CMMotionManager()
    let sampling_rate = 10.0
    var motionTimer = Timer()
    var accelData : [Dictionary<String, Double>] = []    // acceleration measured in G's
    var rotData : [Dictionary<String, Double>] = []      // rotation rate measured in radians/sec
    var magfieldData : [Dictionary<String, Double>] = [] // magnetic field measured in microteslas
    
    let motionTracker : MotionTracker = MotionTracker(samplingRate: 10.0)
    
    let soundCode = 1005
    var hasStoodUp = false
    var walking = true
    
    var testInProgressView : TestInProgressView!
    
    override func loadView() {
        testInProgressView = TestInProgressView(includeDataLabel: false)
        view = testInProgressView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Place the phone in your pocket")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.startTest()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTest() {
//        AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Start walking")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        self.testInProgressView.activityIndicatorView.startAnimating()
        
        // start timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        self.counter  = 0.0
        
        self.motionTracker.startRecording()
        // start collecting data
        self.motionManager.startDeviceMotionUpdates()
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.startGyroUpdates()
        self.motionManager.startMagnetometerUpdates()
        self.motionTimer = Timer.scheduledTimer(timeInterval: 1 / self.sampling_rate, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
        
        self.accelData = []
        self.rotData = []
        self.magfieldData = []
    }
    
    func stopTest() {
//        AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Good work!")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        
        self.view.backgroundColor = .white
        
        // stop timer
        self.timer.invalidate()
        
        self.motionTracker.stopRecording()
        // stop collecting data
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopMagnetometerUpdates()
        self.motionTimer.invalidate()
        
        let resultsDict  = ["tug_time" : counter, "sit_to_stand_time" : sit2stand]
        
        let cv = CheckViewController(message: String(format: "Your TUG time was %.1lf seconds. Your sit-to-stand duration is %.1lf seconds", counter, sit2stand), resultsDict : resultsDict, motionTracker:self.motionTracker, testType: "TUG")
        
        self.navigationController!.pushViewController(cv, animated: true)
        
    }
    
    @objc func updateTimer() {
        self.counter += 0.1
        self.testInProgressView.timeLabel.text = String(format: "%.1fs", counter)
    }
    
    @objc func getData() {
        
        if let pitch = motionManager.deviceMotion?.attitude.pitch {
            
//            self.dataLabel.text = "\(pitch)"
            
            if ((pitch >= 1.0 || pitch <= -1.0) && hasStoodUp == false) {
                sit2stand = counter
                hasStoodUp = true
                walking = true
            }
            
            
            if (pitch >= -0.4 && pitch <= 0.4 && hasStoodUp) {
                stopTest()
                return
            }
        }
        
        // get accel data
        if let accelerometerData = motionManager.accelerometerData {
            let accelDict = ["x":accelerometerData.acceleration.x, "y":accelerometerData.acceleration.y, "z": accelerometerData.acceleration.z]
            self.accelData.append(accelDict)
        }
        
        // get rotation data
        if let gyroscopeData = motionManager.gyroData {
            let rotDict = ["x":gyroscopeData.rotationRate.x, "y":gyroscopeData.rotationRate.y, "z": gyroscopeData.rotationRate.z]
            self.rotData.append(rotDict)
        }
        
        // get magnetic field data
        if let magnetometerData = motionManager.magnetometerData {
            let magfieldDict = ["x":magnetometerData.magneticField.x, "y":magnetometerData.magneticField.y, "z": magnetometerData.magneticField.z]
            self.magfieldData.append(magfieldDict)
        }
    }
    
}
