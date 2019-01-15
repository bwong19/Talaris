//
//  TUGViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import CoreMotion

class TUGViewController: UIViewController {
    
    let x_label = UILabel()
    
    let motionManager = CMMotionManager()
    var timer: Timer!
    
//    public init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white

        print("in TUG")
        super.viewDidLoad()
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        x_label.translatesAutoresizingMaskIntoConstraints = false
        x_label.text = "hello"
        x_label.adjustsFontSizeToFitWidth = true
        view.addSubview(x_label)
        x_label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        x_label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        x_label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        x_label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        //        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(HomeViewController.update), userInfo: nil, repeats: true)
        
        for i in 1...5 {
            update()
            sleep(5)
        }
    }
    
    @objc func update() {
        if let accelerometerData = motionManager.accelerometerData {
            x_label.text = accelerometerData.description
            print(accelerometerData)
        }
        //        if let gyroData = motionManager.gyroData {
        //            print(gyroData)
        //        }
        //        if let magnetometerData = motionManager.magnetometerData {
        //            print(magnetometerData)
        //        }
        //        if let deviceMotion = motionManager.deviceMotion {
        //            print(deviceMotion)
        //        }
    }
    
}
        // Do any additional setup after loading the view.
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

