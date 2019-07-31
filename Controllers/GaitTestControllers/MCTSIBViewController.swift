//
//  TUGViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import FirebaseDatabase

//Performs a single 30 second version of MCTSIB test
//TODO: If it is decided to make a version involving 4 MCTSIB tests, build a wrapper around this that creates it 4 times with new command for each
class MCTSIBViewController: GaitTestViewController, AVSpeechSynthesizerDelegate {
    private let SAMPLING_RATE = 10.0
    private let SVM_THRESH = 2.0
    private let SVM_DELTA = 0.15
    private let TEST_DURATION = 30.0 // in seconds
    
    private let synthesizer = AVSpeechSynthesizer()
    private let didFinish = false
    private let soundCode = 1005
    private var numUtterances = 0
    private var totalUtterances = 0

    private var testNumber: Int
    private var finalTime: Double
    
    private let startScripts = [
        "On the word BEGIN, you will stand as still as possible for 30 seconds. Stand with your arms across your chest and your hands touching your opposite shoulders, feet together with ankle bones touching, and hold for 30 seconds. If you lose your balance before the 30 seconds end, please make note of when you lost your balance.",
        "You will now repeat this test with your eyes closed. On the word BEGIN, you will close your eyes and stand as still as possible for 30 seconds. Stand with your arms across your chest and your hands touching your opposite shoulders, feet together with ankle bones touching, and hold for 30 seconds. If you lose your balance before the 30 seconds end, please make note of when you lost your balance.",
        "On the word BEGIN, you will stand as still as possible for 30 seconds. Stand with your arms across your chest and your hands touching your opposite shoulders, feet together with ankle bones touching, and hold for 30 seconds. If you lose your balance before the 30 seconds end, please make note of when you lost your balance.",
        "On the word BEGIN, you will stand as still as possible for 30 seconds. Stand with your arms across your chest and your hands touching your opposite shoulders, feet together with ankle bones touching, and hold for 30 seconds. If you lose your balance before the 30 seconds end, please make note of when you lost your balance."
    ]
    private let endScripts = [
        "You have now completed the first part of this assessment.",
        "You have now completed the second part of this assessment.",
        "You have now completed the third part of this assessment.",
        "You have now completed the assessment."
    ]
    
    public init(testNumber: Int) {
        self.testNumber = testNumber
        finalTime = 0.0
        super.init(samplingRate: SAMPLING_RATE, includeDataLabel: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func setupMotionTracker() {
        motionTracker.handleAccelerationUpdate { accelerometerData in
            let SVM = (pow(accelerometerData.acceleration.x,2) + pow(accelerometerData.acceleration.y,2) + pow(accelerometerData.acceleration.z,2)).squareRoot()
            DispatchQueue.main.async {
                self.testInProgressView.dataLabel?.text = "\(SVM)"
            }
            if ((SVM > 1.0 + self.SVM_DELTA || SVM < 1.0 - self.SVM_DELTA) || self.counter >= 30) {
                self.finalTime = min(30.0, self.counter)
                self.stopTest()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        synthesizer.delegate = self
        UIApplication.shared.isIdleTimerDisabled = true
        
        navigationItem.hidesBackButton = false
        
        startTest()
    }
    
    override func startTest() {
        if (testNumber == 0) {
            synthesizer.speak(getUtterance("The mCTSIB is a test used to measure balance. Before you begin, please make sure you are standing comfortably on a hard surface. You will be asked to stand still for 30 seconds on a hard surface first with your eyes open, then with your eyes closed. When you are ready, please press the NEXT button on the screen. If you want to repeat the instructions, please press the REPEAT button."))

            synthesizer.speak(getUtterance("Please secure your phone to your abdomen using the provided phone clip. If you would like to hear the instructions again, please press REPEAT. Otherwise, once the phone is secured, please stand still for at least 5 seconds."))
        }

        synthesizer.speak(getUtterance(startScripts[testNumber]))

        synthesizer.speak(getUtterance("Ready?"))
        
        synthesizer.speak(getUtterance("Test starting in 5 seconds"))
    }
    
    override func stopTest() {
        super.stopTest()
        
        PhoneVoice.speak(speech: endScripts[testNumber] + "If the test was completed properly, please press YES. If not, please press REDO. If you wish to exit this assessment without saving any data, please press CANCEL.")
        
        let score = finalTime
        let resultsDict  : [String : Any] = ["score" : score, "max_score" : 30]

        self.navigationController!.pushViewController(CheckViewController(message: String(format: "Your score is %.1lf/30", score), resultsDict: resultsDict, motionTracker:self.motionTracker, testType: "MCTSIB"), animated: true)        
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
                PhoneVoice.speak(speech: "Begin")
                AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
                super.startTest()
            }
        }
    }
    
}
