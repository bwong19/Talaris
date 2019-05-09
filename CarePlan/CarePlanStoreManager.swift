//
//  CarePlanStoreManager.swift
//  Talaris
//
//  Created by Taha Baig on 4/22/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import Foundation
import CareKit

class CarePlanStoreManager : NSObject {
    static let sharedCarePlanStoreManager = CarePlanStoreManager()
    var store: OCKCarePlanStore
    
    override init() {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Failed to obtain Documents directory!")
        }
        
        let storeURL = documentDirectory.appendingPathComponent("CarePlanStore")
        
        if !fileManager.fileExists(atPath: storeURL.path) {
            try! fileManager.createDirectory(at: storeURL, withIntermediateDirectories: true, attributes: nil)
        }
        self.store = OCKCarePlanStore(persistenceDirectoryURL: storeURL)
        super.init()
    }
}
