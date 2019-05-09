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

class MotionTracker : NSObject, CLLocationManagerDelegate {
    let ref : DatabaseReference!
    let DB_STORE_NAME = "temp_test_data"

    var accelData : [Dictionary<String, Double>]         // acceleration measured in G's
    var rotData : [Dictionary<String, Double>]           // rotation rate measured in radians/sec
    var magfieldData : [Dictionary<String, Double>]      // magnetic field measured in microteslas
    var attitudeData : [Dictionary<String, Double>]      // roll, pitch, and yaw in rads
    var quatData : [Dictionary<String, Double>]          // quaternion vector data
    var azimuthData : [Double]                           // compass heading in degrees
    var curAzimuth = -1.0

    let motionManager : CMMotionManager
    let locationManager : CLLocationManager
    var motionTimer : Timer

    let samplingRate : Double
    
    init(samplingRate : Double = 10.0) {
        self.ref = Database.database().reference()
        
        self.accelData = []
        self.rotData = []
        self.magfieldData = []
        self.attitudeData = []
        self.quatData = []
        self.azimuthData = []
        
        self.motionManager = CMMotionManager()
        self.locationManager = CLLocationManager()
        self.motionTimer = Timer()
        
        self.samplingRate = samplingRate
        
        super.init()
        
        self.locationManager.delegate = self
    }
    
    func startRecording() {
        self.motionManager.startDeviceMotionUpdates()
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.startGyroUpdates()
        self.motionManager.startMagnetometerUpdates()
        self.motionTimer = Timer.scheduledTimer(timeInterval: 1 / self.samplingRate, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
        
        self.locationManager.startUpdatingHeading()
    }
    
    @objc func getData() {
        if let yaw = motionManager.deviceMotion?.attitude.yaw,
            let pitch = motionManager.deviceMotion?.attitude.pitch,
            let roll = motionManager.deviceMotion?.attitude.roll {
            
            let attitudeDict = ["roll":roll, "pitch":pitch, "yaw": yaw]
            self.attitudeData.append(attitudeDict)
        }
        
        if let quaternionData = motionManager.deviceMotion?.attitude.quaternion {
            let quaternionDict = ["w": quaternionData.w, "x": quaternionData.x, "y": quaternionData.y, "z": quaternionData.z]
            self.quatData.append(quaternionDict)
        }
        
        // get accel data
        if let accelerometerData = motionManager.accelerometerData {
            let accelDict = ["x":accelerometerData.acceleration.x, "y":accelerometerData.acceleration.y, "z": accelerometerData.acceleration.z]
            self.accelData.append(accelDict)
        }
        
        // get rotation data
        if let gyroscopeData = motionManager.gyroData {
            let rotDict = ["x":gyroscopeData.rotationRate.x, "y":gyroscopeData.rotationRate.y, "z": gyroscopeData.rotationRate.z]
            self.rotData.append(rotDict)
        }
        
        // get magnetic field data
        if let magnetometerData = motionManager.magnetometerData {
            let magfieldDict = ["x":magnetometerData.magneticField.x, "y":magnetometerData.magneticField.y, "z": magnetometerData.magneticField.z]
            self.magfieldData.append(magfieldDict)
        }
        
        self.azimuthData.append(self.curAzimuth)
    }
    
    func stopRecording() {
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopMagnetometerUpdates()
        
        self.locationManager.stopUpdatingHeading()
        
        self.motionTimer.invalidate()
    }
    
    
    func saveAndClearData(testName: String, testResults : Dictionary<String, Any>? = nil) {
        var dataDict : Dictionary<String, Any> = [
            "sampling_rate": self.samplingRate,
            "acceleration": self.accelData,
            "rotation_rate": self.rotData,
            "magnetic_field": self.magfieldData,
            "attitude_euler": self.attitudeData,
            "attitude_quaternion": self.quatData,
            "azimuth": self.azimuthData,
            "correctedAzimuth": SIXMWTViewController.processAzimuthData(azimuthData: self.azimuthData)
        ]
        
        if let resultsDict = testResults {
            resultsDict.forEach { key_val_pair in dataDict[key_val_pair.key] = key_val_pair.value }
        }
        
        self.ref.child(DB_STORE_NAME).child("\(testName)_\(self.getDatetime())").setValue(dataDict)
        
        self.clearData()
    }
    
    func clearData() {
        self.accelData.removeAll()
        self.rotData.removeAll()
        self.magfieldData.removeAll()
        self.attitudeData.removeAll()
        self.quatData.removeAll()
        self.azimuthData.removeAll()
        self.curAzimuth = -1.0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.curAzimuth = newHeading.trueHeading
    }
    
    func getDatetime() -> String {
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
    
}
