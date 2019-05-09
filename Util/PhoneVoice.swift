//
//  PhoneVoice.swift
//  Talaris
//
//  Created by Taha Baig on 5/9/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import AVFoundation

class PhoneVoice {
    private static let synthesizer = AVSpeechSynthesizer()
    
    static func speak(speech: String) {
        let utterance = AVSpeechUtterance(string: speech)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
}


