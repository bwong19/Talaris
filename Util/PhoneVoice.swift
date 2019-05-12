//
//  PhoneVoice.swift
//  Talaris
//
//  Created by Taha Baig on 5/9/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import AVFoundation

// convenience wrapper class to simply creation of voice commands/speech via iPhone internal speech synthesizer
class PhoneVoice {
    private static let synthesizer = AVSpeechSynthesizer()
    
    static func speak(speech: String) {
        let utterance = AVSpeechUtterance(string: speech)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
}


