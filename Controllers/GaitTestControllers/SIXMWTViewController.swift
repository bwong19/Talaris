//
//  TUGViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import FirebaseDatabase

class SIXMWTViewController: UIViewController, CLLocationManagerDelegate {
    var timer = Timer()
    var counter = 0.0
    var ref : DatabaseReference!
    
    let testDuration = 360.0 // in seconds
    
    let motionTracker : MotionTracker = MotionTracker(samplingRate: 10.0)

    var motionTimer = Timer()
    
    let soundCode = 1005
    
    var lm = CLLocationManager()
    
    let sampling_rate = 10.0
    var curAzimuth = -1.0
    var azimuthData : [Double] = []
    static let threshold = 100.0
    var turnaroundDistace : Double
    
    var testInProgressView : TestInProgressView!
    
    public init(turnaroundDistance: Double) {
        self.turnaroundDistace = turnaroundDistance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.turnaroundDistace = -1.0
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        testInProgressView = TestInProgressView(includeDataLabel: false)
        view = testInProgressView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Database.database().reference()
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.startTest()
        })
        
    }
    
    func startTest() {
        //AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        self.testInProgressView.activityIndicatorView.startAnimating()
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Start walking")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        
        // start timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        self.counter  = 0.0
        
        self.motionTracker.startRecording()
        lm.delegate = self
        lm.startUpdatingHeading()
        self.motionTimer = Timer.scheduledTimer(timeInterval: 1 / self.sampling_rate, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
    }
    
    static func processAzimuthData(azimuthData: [Double]) -> [Double] {
        var processedData = azimuthData
        for i in 0..<(azimuthData.count - 1) {
            let diff = abs(processedData[i] - processedData[i + 1])
            if (diff >= self.threshold) {
                var j = i + 1
                if (processedData[i] > processedData[j]) {
                    while (j < azimuthData.count && abs(processedData[i] - processedData[j]) >= self.threshold) {
                        processedData[j] = processedData[j] + diff
                        j += 1
                    }
                } else {
                    while (j < azimuthData.count && abs(processedData[i] - processedData[j]) >= self.threshold) {
                        processedData[j] = processedData[j] - diff
                        j += 1
                    }
                }
            }
        }
        
        return processedData
    }

    func getRotationCount(azimuthData: [Double]) -> (Int, Double){
        var startIndex : Int = 0
        var turnCount : Int = 0
        
        var distance : Double = 0
        var lastTurnIndex = 0
        
        while startIndex < azimuthData.count {
            let endIndex = min(azimuthData.count - 1, startIndex + Int(3 * self.sampling_rate))
            
            let delta = abs(azimuthData[endIndex] - azimuthData[startIndex])
            if (delta >= 150) {
                turnCount += 1
                startIndex = endIndex + 1
                lastTurnIndex = startIndex
            } else {
                startIndex += 1
            }
        }
        
        let timeBeforeLastTurn = Double(lastTurnIndex) / self.sampling_rate
        let timeAfterLastTurn = Double((azimuthData.count - lastTurnIndex)) / self.sampling_rate
        distance = Double(turnCount) * self.turnaroundDistace
        distance += (distance / timeBeforeLastTurn) * timeAfterLastTurn
        return (turnCount, distance)
    }
    
    func stopTest() {
        self.motionTracker.stopRecording()
        
        // stop timer
        self.timer.invalidate()
        self.motionTimer.invalidate()
        lm.stopUpdatingHeading()
        
        //AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Good work!")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        
        self.view.backgroundColor = .white

        let processedAzimuthData = SIXMWTViewController.processAzimuthData(azimuthData: self.azimuthData)
        let res = getRotationCount(azimuthData: processedAzimuthData)
        self.ref.child("azimuth_test").setValue(azimuthData)
        self.ref.child("processed_azimuth_test").setValue(processedAzimuthData)
        
        let resultsDict  : [String : Any] = ["6mwt_distance" : res.1, "turn_count" : res.0] 
        
        let cv = CheckViewController(message: String(format: "Your 6MWT distance was %.1lf meters. Turn Count was %d", res.1, res.0), resultsDict : resultsDict, motionTracker:self.motionTracker, testType: "6MWT")
        self.navigationController!.pushViewController(cv, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.curAzimuth = newHeading.trueHeading
    }
    
    @objc func updateTimer() {
        self.counter += 0.1
        self.testInProgressView.timeLabel.text = String(format: "%.1fs", counter)
    }
    
    @objc func getData() {
        if (self.curAzimuth < 0) {
            return
        }
        
        self.azimuthData.append(self.curAzimuth)
        if (self.counter > self.testDuration) {
            stopTest()
        }
    }
}
