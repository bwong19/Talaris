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

class SIXMWTViewController: GaitTestViewController, CLLocationManagerDelegate, AVSpeechSynthesizerDelegate {
    private let TEST_DURATION = 120.0 // in seconds
    private let SAMPLING_RATE = 50.0
    private let ROTATION_DETECTION_THRESHOLD = 150.0
    
    private let synthesizer = AVSpeechSynthesizer()
    private let didFinish = false
    private let soundCode = 1254
    private let endSoundCode = 1022
    private var numUtterances = 0
    private var totalUtterances = 0

    private var turnaroundDistace : Double
    
    private var azimuths: [Double] = []
    private var accumAzimuthCorrection: Double = 0
    private var lastTurnIndex: Int = 0
    private var turnCount: Int = 0
    
    init(turnaroundDistance: Double = 30, appMode: AppMode, delegate: GaitTestDelegate? = nil) {
        self.turnaroundDistace = turnaroundDistance
        super.init(samplingRate: SAMPLING_RATE, appMode: appMode, delegate: delegate, includeDataLabel: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.delegate = self
        UIApplication.shared.isIdleTimerDisabled = true
        self.navigationItem.hidesBackButton = true
        
        startTest()
    }
    
    override func startTest() {
//        if (mode == AppMode.CareKit) {
//            synthesizer.speak(getUtterance("The Six Minute Walk Test is a gait assessment meant to measure endurance. Before you begin the test, please make sure you have set up two cones between 12 meters and 30 meters apart. Please wear your regular footwear and use a walking aid, if needed. After you have set up the two cones, please enter the distance between them and press the NEXT button on the screen. If you want to repeat the instructions, please press the REPEAT button."))
//            
//            synthesizer.speak(getUtterance("Remember that the objective is to walk AS FAR AS POSSIBLE for 6 minutes, but do not run or jog. You will soon be instructed to start. Please position yourself at your starting cone, and secure your phone at your waist using the provided phone clip. If you want to repeat the instructions, please press the REPEAT button. Otherwise, once you have secured the phone to your waist, please stand still for at least 5 seconds.")) // TODO: "and clicked the NEXT button?
//        
//            synthesizer.speak(getUtterance("On the words BEGIN WALKING, start walking."))
//        }
        synthesizer.speak(getUtterance("Ready?"))
    }
    
    override func setupMotionTracker() {
        motionTracker.handleAzimuthUpdate { azimuth in
            let curIndex = self.azimuths.count
            self.azimuths.append(azimuth)
            
            // real-time smoothing of azimuth signal
            self.azimuths[curIndex] -= self.accumAzimuthCorrection
            if (curIndex > 0) {
                let diff = self.azimuths[curIndex] - self.azimuths[curIndex - 1]
                if (abs(diff) >= MotionTracker.AZIMUTH_PROCESSING_THRESHOLD) {
                    self.accumAzimuthCorrection += diff
                    self.azimuths[curIndex] -= diff
                }
            }
            
            // real-time turn detection
            let endIndex = curIndex
            let startIndex = endIndex - Int(3 * self.SAMPLING_RATE)
            if (startIndex >= self.lastTurnIndex) {
                let delta = abs(self.azimuths[endIndex] - self.azimuths[startIndex])
                if (delta >= self.ROTATION_DETECTION_THRESHOLD) {
                    self.lastTurnIndex = curIndex
                    self.turnCount += 1
                    PhoneVoice.speak(speech: "Turn \(self.turnCount)")
                }
            }
        }
    }

    override func stopTest() {
        super.stopTest()
        AudioServicesPlaySystemSound(SystemSoundID(self.endSoundCode))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             PhoneVoice.speak(speech: "Stop walking. Good Work!")
        }
        
        var distance: Double = 0.0
        if turnCount != 0 {
            let timeBeforeLastTurn = Double(lastTurnIndex) / SAMPLING_RATE
            let timeAfterLastTurn = Double((azimuths.count - lastTurnIndex)) / SAMPLING_RATE
            distance = Double(turnCount) * turnaroundDistace
            distance += (distance / timeBeforeLastTurn) * timeAfterLastTurn
        }
        
        let resultsDict: [String: Any] = ["distance" : distance, "turn_count" : turnCount]
        
        delegate?.onGaitTestComplete(
            resultsDict: resultsDict,
            resultsMessage: String(format: "Your 2MWT distance is %.1lf meters. Turn Count is %d.", distance, turnCount),
            gaitTestType: GaitTestType.SixMWT,
            motionTracker: motionTracker
        )
    }

    @objc override func updateTimer() {
        // Rounds counter to the nearest second based on TIME_INTERVAL
        switch (Int(10 * counter + 0.5)) {
        case 600:
            PhoneVoice.speak(speech: "You are doing well. You have 1 minute to go.")
//        case 1200:
//            PhoneVoice.speak(speech: "Keep up the good work. You have 4 minutes to go.")
//        case 1800:
//            PhoneVoice.speak(speech: "You are doing well. You are halfway done.")
//        case 2400:
//            PhoneVoice.speak(speech: "Keep up the good work. You have only 2 minutes left.")
//        case 3000:
//            PhoneVoice.speak(speech: "You are doing well. You have only 1 minute to go.")
        default:
            break
        }
        super.updateTimer()
        if (counter > TEST_DURATION) {
            stopTest()
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
        if (numUtterances == totalUtterances) {
            synthesizer.delegate = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                AudioServicesPlaySystemSound(SystemSoundID(self.soundCode))
                super.startTest()
            }
        }
    }
}
