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

class SIXMWTViewController: GaitTestViewController, CLLocationManagerDelegate {
    private let TEST_DURATION = 60.0 // in seconds
    private let SAMPLING_RATE = 10.0
    private let ROTATION_DETECTION_THRESHOLD = 150.0

    private var turnaroundDistace : Double
    
    init(turnaroundDistance: Double) {
        self.turnaroundDistace = turnaroundDistance
        super.init(samplingRate: SAMPLING_RATE, includeDataLabel: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        self.navigationItem.hidesBackButton = true
        PhoneVoice.speak(speech: "The Six Minute Walk Test is a gait assessment meant to measure endurance. Before you begin the test, please make sure you have set up two cones between 12 meters and 30 meters apart. Please wear your regular footwear and use a walking aid, if needed. After you have set up the two cones, please enter the distance between them and press the NEXT button on the screen. If you want to repeat the instructions, please press the REPEAT button.")
        
        
        // TODO: next/repeat button here
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(35)) {
            PhoneVoice.speak(speech: "Remember that the objective is to walk AS FAR AS POSSIBLE for 6 minutes, but do not run or jog. You will soon be instructed to start. Please position yourself at your starting cone, and secure your phone at your waist using the provided phone clip. If you want to repeat the instructions, please press the REPEAT button. Otherwise, once you have secured the phone to your waist, please stand still for at least 5 seconds.") // TODO: "and clicked the NEXT button?
        }
        // TODO: next/repeat button here
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(70)) {
            PhoneVoice.speak(speech: "On the words BEGIN WALKING, start walking.")
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(80)) {
            PhoneVoice.speak(speech: "Ready?")
            self.startTest()
        }
        
    }
    
    override func startTest() {
        super.startTest()
        PhoneVoice.speak(speech: "Begin walking.")
    }

    override func stopTest() {
        super.stopTest()
        PhoneVoice.speak(speech: "Stop walking.")
        
        let results = getRotationCountAndDistance(azimuthData: motionTracker.processedAzimuthData)
        let resultsDict  : [String : Any] = ["distance" : results.1, "turn_count" : results.0]
        let cv = CheckViewController(message: String(format: "Your 6MWT distance was %.1lf meters. Turn Count was %d", results.1, results.0), resultsDict : resultsDict, motionTracker:self.motionTracker, testType: "6MWT")
        self.navigationController!.pushViewController(cv, animated: true)
        
    }

    @objc override func updateTimer() {
        super.updateTimer()
        if (counter > TEST_DURATION) {
            stopTest()
        }
        switch (counter) {
        case 600.0:
            PhoneVoice.speak(speech: "You are doing well. You have 5 minutes to go.")
        case 1200.0:
            PhoneVoice.speak(speech: "Keep up the good work. You have 4 minutes to go.")
        case 1800.0:
            PhoneVoice.speak(speech: "You are doing well. You are halfway done.")
        case 2400.0:
            PhoneVoice.speak(speech: "Keep up the good work. You have only 2 minutes left.")
        case 3000.0:
            PhoneVoice.speak(speech: "You are doing well. You have only 1 minute to go.")
        default:
            break
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
    
}
