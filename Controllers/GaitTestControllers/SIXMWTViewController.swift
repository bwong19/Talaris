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
    private let SAMPLING_RATE = 10.0
    private let ROTATION_DETECTION_THRESHOLD = 150.0
    
    private let synthesizer = AVSpeechSynthesizer()
    private let didFinish = false
    private let soundCode = 1005
    private var numUtterances = 0
    private var totalUtterances = 0

    private var turnaroundDistace : Double
    private var mode: AppMode
    
    init(turnaroundDistance: Double = 30, appMode: AppMode) {
        mode = appMode
        self.turnaroundDistace = turnaroundDistance
        super.init(samplingRate: SAMPLING_RATE, includeDataLabel: false)
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
        if (mode == AppMode.CareKit) {
            synthesizer.speak(getUtterance("The Six Minute Walk Test is a gait assessment meant to measure endurance. Before you begin the test, please make sure you have set up two cones between 12 meters and 30 meters apart. Please wear your regular footwear and use a walking aid, if needed. After you have set up the two cones, please enter the distance between them and press the NEXT button on the screen. If you want to repeat the instructions, please press the REPEAT button."))
            
            synthesizer.speak(getUtterance("Remember that the objective is to walk AS FAR AS POSSIBLE for 6 minutes, but do not run or jog. You will soon be instructed to start. Please position yourself at your starting cone, and secure your phone at your waist using the provided phone clip. If you want to repeat the instructions, please press the REPEAT button. Otherwise, once you have secured the phone to your waist, please stand still for at least 5 seconds.")) // TODO: "and clicked the NEXT button?
        
            synthesizer.speak(getUtterance("On the words BEGIN WALKING, start walking."))
        }
        synthesizer.speak(getUtterance("Ready?"))
}

    override func stopTest() {
        super.stopTest()
        PhoneVoice.speak(speech: "Stop walking.")
        
        let results = getRotationCountAndDistance(azimuthData: motionTracker.processedAzimuthData)
        let resultsDict  : [String : Any] = ["distance" : results.1, "turn_count" : results.0]
        if (mode == AppMode.CareKit) {
            let cv = CheckViewController(message: String(format: "Your 6MWT distance was %.1lf meters. Turn Count was %d.", results.1, results.0), resultsDict : resultsDict, motionTracker:self.motionTracker, testType: "6MWT")
            self.navigationController!.pushViewController(cv, animated: true)
        } else if (mode == AppMode.Clinical) {
            let cv = ClinicalCheckViewController(message: String(format: "Your 6MWT distance was %.1lf meters. Turn Count was %d.", results.1, results.0), resultsDict : resultsDict, motionTracker:self.motionTracker, testType: "6MWT")
            self.navigationController!.pushViewController(cv, animated: true)
        }
    }

    @objc override func updateTimer() {
        // Rounds counter to the nearest second based on TIME_INTERVAL
        switch (Int(10 * counter + 0.5)) {
        case 600:
            PhoneVoice.speak(speech: "You are doing well. You have 5 minutes to go.")
        case 1200:
            PhoneVoice.speak(speech: "Keep up the good work. You have 4 minutes to go.")
        case 1800:
            PhoneVoice.speak(speech: "You are doing well. You are halfway done.")
        case 2400:
            PhoneVoice.speak(speech: "Keep up the good work. You have only 2 minutes left.")
        case 3000:
            PhoneVoice.speak(speech: "You are doing well. You have only 1 minute to go.")
        default:
            break
        }
        super.updateTimer()
        if (counter > TEST_DURATION) {
            stopTest()
        }
    }
    
    private func getRotationCountAndDistance(azimuthData: [Double]) -> (Int, Double){
        var startIndex : Int = 0
        var turnCount : Int = 0
        
        var distance : Double = 0
        var lastTurnIndex = 0
        
        while startIndex < azimuthData.count {
            let endIndex = min(azimuthData.count - 1, startIndex + Int(3 * SAMPLING_RATE))
            
            let delta = abs(azimuthData[endIndex] - azimuthData[startIndex])
            if (delta >= ROTATION_DETECTION_THRESHOLD) {
                turnCount += 1
                startIndex = endIndex + 1
                lastTurnIndex = startIndex
            } else {
                startIndex += 1
            }
        }
        
        let timeBeforeLastTurn = Double(lastTurnIndex) / SAMPLING_RATE
        let timeAfterLastTurn = Double((azimuthData.count - lastTurnIndex)) / SAMPLING_RATE
        distance = Double(turnCount) * turnaroundDistace
        distance += (distance / timeBeforeLastTurn) * timeAfterLastTurn
        return (turnCount, distance)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
                super.startTest()
            }
        }
    }
}
