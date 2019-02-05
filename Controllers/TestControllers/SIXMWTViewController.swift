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

class SIXMWTViewController: UIViewController {
    var timer = Timer()
    var counter = 0.0
    let timeLabel = UILabel()
    
    let pedometer = CMPedometer()
    var startDate = Date()
    var initDistance = -1.0
    let testDuration = 30.0 // in seconds
    
    var motionTimer = Timer()
    
    let angleLabel = UILabel()
    
    let soundCode = 1005
    var hasStoodUp = false
    
    var finalDistance = 0.0
    
    override func viewDidLoad() {
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
        
        // start collecting data
        self.startDate = Date() - 18000
        print(startDate)
        self.pedometer.startUpdates(from: startDate) { (data, err) in
            if let error = err {
                print(error)
                return
            }
            
            if (self.initDistance < 0) {
                self.initDistance = (data?.distance?.doubleValue)!
            }
            
            DispatchQueue.main.async {
                self.angleLabel.text = "\((data?.distance?.doubleValue)! - self.initDistance)"
                
                print(self.counter)
                if (self.counter >= self.testDuration) {
                    self.finalDistance = (data?.distance?.doubleValue)! - self.initDistance
                    
//
//                    if let distVal = self.angleLabel.text, let dist = Double(self.angleLabel.text) {
//                        self.finalDistance = Double(self.angleLabel.text)
//                    }
                    
                    self.stopTest()
                }
            }
        }
    }
    
    func stopTest() {
        //AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "Good work!")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        
        self.view.backgroundColor = .white
        
        // stop timer
        self.timer.invalidate()
        
        
        self.pedometer.stopUpdates()
        self.navigationController!.pushViewController(CheckViewController(message: String(format: "Your 6MWT distance was %.1lf meters.", self.finalDistance)), animated: true)
    
    }
    
    @objc func updateTimer() {
        self.counter += 0.1
        self.timeLabel.text = String(format: "%.0fs", counter)
    }
}
