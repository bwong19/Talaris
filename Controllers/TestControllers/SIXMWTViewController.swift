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
    let timeLabel = UILabel()
    var ref : DatabaseReference!
    
    let testDuration = 360.0 // in seconds
    
    let motionTracker : MotionTracker = MotionTracker(samplingRate: 10.0)

    var motionTimer = Timer()
    
    let angleLabel = UILabel()
    
    let soundCode = 1005
    
    var lm = CLLocationManager()
    
    let sampling_rate = 10.0
    var curAzimuth = -1.0
    var azimuthData : [Double] = []
    let threshold = 100.0
    var turnaroundDistace : Double
    
    public init(turnaroundDistance: Double) {
        self.turnaroundDistace = turnaroundDistance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.turnaroundDistace = -1.0
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.ref = Database.database().reference()
        UIApplication.shared.isIdleTimerDisabled = true
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        // timer time label
        self.timeLabel.text = "0.0s"
        self.timeLabel.font = timeLabel.font.withSize(72)
        self.timeLabel.adjustsFontSizeToFitWidth = true
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.timeLabel)
        self.timeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.timeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height / 6).isActive = true
        
        // angle label
        self.angleLabel.text = ""
        self.angleLabel.font = timeLabel.font.withSize(36)
        self.angleLabel.adjustsFontSizeToFitWidth = true
        self.angleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.angleLabel)
        self.angleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.angleLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 20).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.startTest()
        })
        
    }
    
    func startTest() {
        //AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Start walking")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        
        self.view.backgroundColor = .green
        // start timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        self.counter  = 0.0
        
        self.motionTracker.startRecording()
        lm.delegate = self
        lm.startUpdatingHeading()
        self.motionTimer = Timer.scheduledTimer(timeInterval: 1 / self.sampling_rate, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
    }
    
    func processAzimuthData(azimuthData: [Double]) -> [Double] {
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
            if (delta >= 100) {
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

        let processedAzimuthData = self.processAzimuthData(azimuthData: self.azimuthData)
        let res = getRotationCount(azimuthData: processedAzimuthData)
        self.ref.child("azimuth_test").setValue(azimuthData)
        self.ref.child("processed_azimuth_test").setValue(processedAzimuthData)
        
        self.navigationController!.pushViewController(CheckViewController(message: String(format: "Your 6MWT distance was %.1lf meters. Turn Count was %d", res.1, res.0), motionTracker:self.motionTracker, testType: "6MWT"), animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //self.angleLabel.text = "\(newHeading.trueHeading)"
        self.curAzimuth = newHeading.trueHeading
    }
    
    @objc func updateTimer() {
        self.counter += 0.1
        self.timeLabel.text = String(format: "%.0fs", counter)
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
