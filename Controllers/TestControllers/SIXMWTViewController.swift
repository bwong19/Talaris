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
    
    let testDuration = 10.0 // in seconds
    
    var motionTimer = Timer()
    
    let angleLabel = UILabel()
    
    let soundCode = 1005
    
    var lm = CLLocationManager()
    
    let sampling_rate = 10.0
    var curAzimuth = -1.0
    var azimuthData : [Double] = []
    
    override func viewDidLoad() {
        self.ref = Database.database().reference()
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
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
        
        
        lm.delegate = self
        lm.startUpdatingHeading()
        self.motionTimer = Timer.scheduledTimer(timeInterval: 1 / self.sampling_rate, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
    }
    
    func stopTest() {
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
        
        
        
        print(self.azimuthData.count)
        self.ref.child("azimuth_test").setValue(azimuthData)
        
        self.navigationController!.pushViewController(CheckViewController(message: String(format: "Your 6MWT distance was %.1lf meters.", -1.0)), animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.angleLabel.text = "\(newHeading.trueHeading)"
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
