//
//  TUGViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation


class TUGViewController: UIViewController {
    var timer = Timer()
    var counter = 0.0
    var sit2stand = 0.0
    var stand2sit = 0.0
    let timeLabel = UILabel()
    
    let motionManager = CMMotionManager()
    let sampling_rate = 10.0
    var motionTimer = Timer()
    var accelData : [Dictionary<String, Double>] = []    // acceleration measured in G's
    var rotData : [Dictionary<String, Double>] = []      // rotation rate measured in radians/sec
    var magfieldData : [Dictionary<String, Double>] = [] // magnetic field measured in microteslas
    
    let angleLabel = UILabel()
    
    let soundCode = 1005
    var hasStoodUp = false
    var walking = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // timer time label
        self.timeLabel.text = "0.0"
        self.timeLabel.font = timeLabel.font.withSize(72)
        self.timeLabel.adjustsFontSizeToFitWidth = true
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.timeLabel)
        self.timeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.timeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height / 6).isActive = true
        
        // angle label
        self.angleLabel.text = ""
        self.angleLabel.font = timeLabel.font.withSize(36)
        self.angleLabel.adjustsFontSizeToFitWidth = true
        self.angleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.angleLabel)
        self.angleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.angleLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 20).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.startTest()
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startTest() {
        AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        self.view.backgroundColor = .green
        // start timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        self.counter  = 0.0
        self.timeLabel.text = "0.0"
        
        // start collecting data
        self.motionManager.startDeviceMotionUpdates()
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.startGyroUpdates()
        self.motionManager.startMagnetometerUpdates()
        self.motionTimer = Timer.scheduledTimer(timeInterval: 1 / self.sampling_rate, target: self, selector: #selector(self.getData), userInfo: nil, repeats: true)
        
        self.accelData = []
        self.rotData = []
        self.magfieldData = []
    }
    
    func stopTest() {
        AudioServicesPlaySystemSound(SystemSoundID(self.soundCode));
        self.view.backgroundColor = .white
        
        // stop timer
        self.timer.invalidate()
        
        // stop collecting data
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopMagnetometerUpdates()
        self.motionTimer.invalidate()
        
        self.navigationController!.pushViewController(CheckViewController(result: counter, sit2stand: sit2stand), animated: true)
        
    }
    
    @objc func updateTimer() {
        self.counter += 0.1
        self.timeLabel.text = String(format: "%.1f", counter)
    }
    
    @objc func getData() {
        
        if let pitch = motionManager.deviceMotion?.attitude.pitch {
            
            self.angleLabel.text = "\(pitch)"
            
            if ((pitch >= 1.0 || pitch <= -1.0) && hasStoodUp == false) {
                sit2stand = counter
                hasStoodUp = true
                walking = true
            }
            
            
            if (pitch >= -0.5 && pitch <= 0.5 && hasStoodUp) {
                stopTest()
                return
            }
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // stop timer
        self.timer.invalidate()
        
        // stop collecting data
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopMagnetometerUpdates()
        self.motionTimer.invalidate()
        
        super.viewWillDisappear(animated)
    }
    
}
