//
//  GaitTestUtil.swift
//  Talaris
//
//  Created by Brandon Wong on 9/21/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import Foundation

enum TestType: Int {
    case SixMWT = 0
    case MCTSIB = 1
    case TUG = 2
}

enum MCTSIBTestType: Int {
    case EyesOpenFirmSurface = 0
    case EyesClosedFirmSurface = 1
    case EyesOpenSoftSurface = 2
    case EyesClosedSoftSurface = 3
}


enum AppMode: Int {
    case CareKit = 0
    case Clinical = 1
}
