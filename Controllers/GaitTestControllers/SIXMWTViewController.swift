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
    private let TEST_DURATION = 10.0 // in seconds
    private let SAMPLING_RATE = 10.0
    private let ROTATION_DETECTION_THRESHOLD = 150.0

    private var turnaroundDistace : Double!
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.startTest()
        })
        
    }
    
    override func startTest() {
        super.startTest()
        PhoneVoice.speak(speech: "Start walking")
    }

    override func stopTest() {
        super.stopTest()
        PhoneVoice.speak(speech: "Good work!")
        
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
