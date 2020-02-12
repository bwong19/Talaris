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
    private let SAMPLING_RATE = 100.0
    private let STANDING_THRESHOLD = 1.0
    private let SITTING_THRESHOLD = 0.5

    private var sit2stand: Double
    private var stand2sit: Double
    
    private var hasStoodUp: Bool
    private var walking: Bool
    
    private let synthesizer = AVSpeechSynthesizer()
    private let didFinish = false
    private let soundCode = 1254
    private let endSoundCode = 1022
    private var numUtterances = 0
    private var totalUtterances = 0
    private var testStarted: Bool
    private var testStopped: Bool
    
    init(appMode: AppMode, delegate: GaitTestDelegate? = nil) {
        sit2stand = 0.0
        stand2sit = 0.0
        hasStoodUp = false
        walking = false
        testStarted = false
        testStopped = false
        
        super.init(samplingRate: SAMPLING_RATE, appMode: appMode, delegate: delegate, includeDataLabel: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func setupMotionTracker() {
        motionTracker.handleAttitudeUpdate { attitude in
            self.testInProgressView.dataLabel?.text = "\(attitude.pitch)"
            if ((attitude.pitch >= self.STANDING_THRESHOLD || attitude.pitch <= -self.STANDING_THRESHOLD) && self.hasStoodUp == false) {
                self.sit2stand = Double(self.motionTracker.attitudeData.count) / self.SAMPLING_RATE
                self.hasStoodUp = true
                self.walking = true
            }

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
                 PhoneVoice.speak(speech: "Good Work!")
            }
        }
        
        let tug_time = Double(self.motionTracker.attitudeData.count) / self.SAMPLING_RATE
        let resultsDict: [String: Any] = [
            "tug_time": tug_time,
            "sit_to_stand_time": sit2stand
        ]
        
        delegate?.onGaitTestComplete(
            resultsDict: resultsDict,
            resultsMessage: String(
                format: "Your TUG time is %.2f seconds. Your sit-to-stand duration is %.2f seconds.",
                tug_time,
                sit2stand
            ),
            gaitTestType: GaitTestType.TUG,
            motionTracker: motionTracker
        )
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
            synthesizer.delegate = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                super.startTest()
                AudioServicesPlaySystemSound(SystemSoundID(self.soundCode))
                self.testStarted = true
            }
        }
    }
}
