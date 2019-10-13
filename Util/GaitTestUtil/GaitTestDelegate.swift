//
//  GaitTestDelegate.swift
//  Talaris
//
//  Created by Taha Baig on 10/13/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

protocol GaitTestDelegate:class {
    func onGaitTestComplete(resultsDict: Dictionary<String, Any>, resultsMessage: String, gaitTestType: GaitTestType, motionTracker: MotionTracker)
}
