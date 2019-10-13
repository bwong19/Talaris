//
//  MotionTracker.swift
//  Talaris
//
//  Created by Taha Baig on 4/18/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import Foundation
import CoreMotion
import CoreLocation
import FirebaseDatabase

// MotionTracker object, records all acceleration, gyroscopic, orientation, heading, etc. data in the background
// provides callback functions to access recorded data in real time
class MotionTracker : NSObject, CLLocationManagerDelegate {
    private let ref: DatabaseReference
    private let DB_STORE_NAME = "temp_test_data"
    private static let AZIMUTH_PROCESSING_THRESHOLD = 100.0

    let samplingRate: Double

    private let motionManager: CMMotionManager
    private let locationManager: CLLocationManager
    private var motionTimer: Timer
    
    // motion data storage
    var attitudeData: [Dictionary<String, Double>]      // roll, pitch, and yaw in rads
    var quatData: [Dictionary<String, Double>]          // quaternion vector data
    var accelData: [Dictionary<String, Double>]         // acceleration measured in G's
    var rotData: [Dictionary<String, Double>]           // rotation rate measured in radians/sec
    var magfieldData: [Dictionary<String, Double>]      // magnetic field measured in microteslas
    var azimuthData: [Double]                           // compass heading in degrees
    var processedAzimuthData: [Double]                  // processed azimuth (smoothed data i.e. removes spikes from 0 to 360 degree jumps)
    var curAzimuth: Double
    
    // definining callback methods to get realtime motion updates
    private var processAttitudeUpdate: ((CMAttitude) -> ())?
    private var processAccelUpdate: ((CMAccelerometerData) -> ())?
    
    init(samplingRate: Double = 10.0) {
        ref = Database.database().reference()
        
        self.samplingRate = samplingRate

        motionManager = CMMotionManager()
        locationManager = CLLocationManager()
        motionTimer = Timer()
        
        quatData = []
        azimuthData = []
        accelData = []
        rotData = []
        magfieldData = []
        attitudeData = []
        processedAzimuthData = []
        curAzimuth = -1.0
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func startRecording() {
        motionManager.startDeviceMotionUpdates()
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionTimer = Timer.scheduledTimer(timeInterval: 1 / samplingRate, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
        
        locationManager.startUpdatingHeading()
    }
    
    @objc private func getData() {
        // get current orientation (both yaw, pitch, roll (attitude) and quaternion based)
        if let yaw = motionManager.deviceMotion?.attitude.yaw,
            let pitch = motionManager.deviceMotion?.attitude.pitch,
            let roll = motionManager.deviceMotion?.attitude.roll {
            
            processAttitudeUpdate?(motionManager.deviceMotion!.attitude)
            let attitudeDict = ["roll":roll, "pitch":pitch, "yaw": yaw]
            attitudeData.append(attitudeDict)
        }
        if let quaternionData = motionManager.deviceMotion?.attitude.quaternion {
            let quaternionDict = ["w": quaternionData.w, "x": quaternionData.x, "y": quaternionData.y, "z": quaternionData.z]
            quatData.append(quaternionDict)
        }
        
        // get accel data
        if let accelerometerData = motionManager.accelerometerData {
            processAccelUpdate?(accelerometerData)
            let accelDict = ["x":accelerometerData.acceleration.x, "y":accelerometerData.acceleration.y, "z": accelerometerData.acceleration.z]
            accelData.append(accelDict)
        }
        
        // get rotation data
        if let gyroscopeData = motionManager.gyroData {
            let rotDict = ["x":gyroscopeData.rotationRate.x, "y":gyroscopeData.rotationRate.y, "z": gyroscopeData.rotationRate.z]
            rotData.append(rotDict)
        }
        
        // get magnetic field data
        if let magnetometerData = motionManager.magnetometerData {
            let magfieldDict = ["x":magnetometerData.magneticField.x, "y":magnetometerData.magneticField.y, "z": magnetometerData.magneticField.z]
            magfieldData.append(magfieldDict)
        }
        
        // get curAzimuth
        azimuthData.append(curAzimuth)
    }
    
    func stopRecording() {
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
        
        locationManager.stopUpdatingHeading()
        
        motionTimer.invalidate()
        
        processedAzimuthData = MotionTracker.processAzimuthData(azimuthData: azimuthData)
    }
    
    
    func saveAndClearData(testName: String, testMode: AppMode, testResults: Dictionary<String, Any>? = nil) {
        var motionData : Dictionary<String, Any> = [
            "sampling_rate": samplingRate,
            "acceleration": accelData,
            "rotation_rate": rotData,
            "magnetic_field": magfieldData,
            "attitude_euler": attitudeData,
            "attitude_quaternion": quatData,
            "azimuth": azimuthData,
            "correctedAzimuth": processedAzimuthData
        ]
        
        if let resultsDict = testResults {
            resultsDict.forEach { key_val_pair in motionData[key_val_pair.key] = key_val_pair.value }
        }
        
        let motionDataStorageName = "\(testName)_\(getDatetime())"
        if (testMode == AppMode.Clinical) {
            saveDataToDocuments(fileName: motionDataStorageName, motionData: motionData)
        } else if (testMode == AppMode.CareKit) {
            ref.child(DB_STORE_NAME).child(motionDataStorageName).setValue(motionData)
        }
        
        clearData()
    }
    
    func clearData() {
        accelData.removeAll()
        rotData.removeAll()
        magfieldData.removeAll()
        attitudeData.removeAll()
        quatData.removeAll()
        azimuthData.removeAll()
        processedAzimuthData.removeAll()
        curAzimuth = -1.0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        curAzimuth = newHeading.trueHeading
    }
    
    private func saveDataToDocuments(fileName: String, motionData : Dictionary<String, Any>) {
        guard let motionDataJson = convertTestDataToJSON(motionData) else {
            return
        }
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        var fileURL = dir.appendingPathComponent("\(fileName).json")
        
        // create empty file
        do {
            try "".write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            return
        }
        
        // set file to NOT be backed up to iCloud (only want local device storage)
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try fileURL.setResourceValues(resourceValues)
        } catch {
            return
        }
        
        do {
            try motionDataJson.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            return
        }
    }
    
    private func convertTestDataToJSON(_ motionData : Dictionary<String, Any>) -> String? {
        var motionDataJson: String? = nil
        do {
            let motionDataJsonData = try JSONSerialization.data(withJSONObject: motionData, options: .prettyPrinted)
            motionDataJson = String(data: motionDataJsonData, encoding: .utf8)!
        } catch {
            return nil
        }
        
        return motionDataJson
    }
    
    private func getDatetime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        return String(format: "%04d-%02d-%02d-%02d:%02d:%02d", year, month, day, hour, minute, seconds)
    }
    
    // smooths azimuth data i.e. removes spikes from 0 to 360 degree jumps
    private static func processAzimuthData(azimuthData: [Double]) -> [Double] {
        var processedData = azimuthData
        for i in 0..<(azimuthData.count - 1) {
            let diff = abs(processedData[i] - processedData[i + 1])
            if (diff >= AZIMUTH_PROCESSING_THRESHOLD) {
                var j = i + 1
                if (processedData[i] > processedData[j]) {
                    while (j < azimuthData.count && abs(processedData[i] - processedData[j]) >= AZIMUTH_PROCESSING_THRESHOLD) {
                        processedData[j] = processedData[j] + diff
                        j += 1
                    }
                } else {
                    while (j < azimuthData.count && abs(processedData[i] - processedData[j]) >= AZIMUTH_PROCESSING_THRESHOLD) {
                        processedData[j] = processedData[j] - diff
                        j += 1
                    }
                }
            }
        }
        
        return processedData
    }

    func handleAttitudeUpdate(_ callback: @escaping (CMAttitude) -> ()) {
        processAttitudeUpdate = callback
    }
    
    func handleAccelerationUpdate(_ callback: @escaping (CMAccelerometerData) -> ()) {
        processAccelUpdate = callback
    }
    
}
