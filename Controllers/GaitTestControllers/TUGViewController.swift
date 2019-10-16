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
class TUGViewController: GaitTestViewController, AVSpeechSynthesizerDelegate {
    private let SAMPLING_RATE = 10.0
    private let STANDING_THRESHOLD = 1.0
    private let SITTING_THRESHOLD = 0.4

    private var sit2stand: Double
    private var stand2sit: Double
    
    private var hasStoodUp: Bool
    private var walking: Bool
    
    private let synthesizer = AVSpeechSynthesizer()
    private let didFinish = false
    private let soundCode = 1005
    private let endSoundCode = 1022
    private var numUtterances = 0
    private var totalUtterances = 0
    private var testStarted: Bool
    private var testStopped: Bool
    private var mode: AppMode
    
    init(appMode: AppMode) {
        mode = appMode
        sit2stand = 0.0
        stand2sit = 0.0
        hasStoodUp = false
        walking = false
        testStarted = false
        testStopped = false
        
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
            // TODO: yeet this outta here please
            /*
             if ((attitude.pitch <= self.STANDING_THRESHOLD || attitude.pitch >= -self.STANDING_THRESHOLD) && self.walking = true) {
                self.stand2sit = self.counter
             */
            
            
            if (attitude.pitch >= -self.SITTING_THRESHOLD && attitude.pitch <= self.SITTING_THRESHOLD && self.hasStoodUp && !self.testStopped) {
                self.stopTest()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        synthesizer.delegate = self
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.startTest()
        
    }
    
    override func startTest() {
        if (mode == AppMode.CareKit) {
            synthesizer.speak(getUtterance("Please sit down. Then, please secure your phone to your waist using the provided phone clip. Once the phone is secured, please sit still for at least 5 seconds. Please press “REPEAT” to repeat the instructions"))
            
            synthesizer.speak(getUtterance("On the words BEGIN WALKING, you will stand up, walk to the 3-meter mark, turn around, walk back towards the chair. and sit down. Walk at your regular pace."))
        }
        
        synthesizer.speak(getUtterance("Ready?"))
    }
    
    override func stopTest() {
        self.testStopped = true
        super.stopTest()
        
        AudioServicesPlaySystemSound(SystemSoundID(self.endSoundCode))
        
        if (mode == AppMode.CareKit) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.synthesizer.speak(self.getUtterance("Good Work!"))
            }
        }
        
        let resultsDict  = ["tug_time" : counter, "sit_to_stand_time" : sit2stand]
        if (mode == AppMode.CareKit) {
            let cv = CheckViewController(message: String(format: "Your TUG time was %.1lf seconds. Your sit-to-stand duration is %.1lf seconds.", counter, sit2stand), resultsDict : resultsDict as Dictionary<String, Any>, motionTracker:self.motionTracker, testType: "TUG")
            self.navigationController!.pushViewController(cv, animated: true)
        } else if (mode == AppMode.Clinical) {
            let cv = ClinicalCheckViewController(message: String(format: "Your TUG time was %.1lf seconds. Your sit-to-stand duration is %.1lf seconds.", counter, sit2stand), resultsDict : resultsDict as Dictionary<String, Any>, motionTracker:self.motionTracker, testType: "TUG")
            self.navigationController!.pushViewController(cv, animated: true)
        }
    }
    
    func getUtterance(_ speech: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: speech)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.postUtteranceDelay = 1
        totalUtterances += 1
        return utterance
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        numUtterances += 1
        if (numUtterances == totalUtterances && !self.testStarted) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                super.startTest()
                AudioServicesPlaySystemSound(SystemSoundID(self.soundCode))
                self.testStarted = true
            }
        }
    }
}
