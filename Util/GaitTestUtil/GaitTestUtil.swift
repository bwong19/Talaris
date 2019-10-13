//
//  GaitTestUtil.swift
//  Talaris
//
//  Created by Brandon Wong on 9/21/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import Foundation

enum GaitTestType: String {
    case SixMWT = "6MWT"
    case MCTSIB = "MCTSIB"
    case TUG = "TUG"
}

enum MCTSIBTestType: Int {
    case EyesOpenFirmSurface = 0
    case EyesClosedFirmSurface = 1
    case EyesOpenSoftSurface = 2
    case EyesClosedSoftSurface = 3
}
