//
//  GaitAlert.swift
//  Talaris
//
//  Created by Brandon Wong on 10/1/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import Foundation
import UIKit

class GaitAlert {
    
    class func tugAlert(in vc: UIViewController, mode: AppMode) {
        vc.navigationController!.pushViewController(TUGViewController(appMode: mode), animated: true)
    }
    
    class func sixmwtAlert(in vc: UIViewController, mode: AppMode){
        let alert = UIAlertController(title: "Six Minute Walk Test", message: "Please provide the distance from your starting position to the turnaround point (in meters).", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            vc.navigationController!.pushViewController(SIXMWTViewController(turnaroundDistance: Double(textField.text!)!, appMode: mode), animated: true)
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func mctsibAlert(in vc: UIViewController, mode: AppMode) {
        let alert = UIAlertController(title: "MCTSIB", message: "Please select a pose.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Eyes open, firm surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            vc.navigationController!.pushViewController(MCTSIBViewController(testNumber: MCTSIBTestType.EyesOpenFirmSurface, appMode: mode), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Eyes closed, firm surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            vc.navigationController!.pushViewController(MCTSIBViewController(testNumber: MCTSIBTestType.EyesClosedFirmSurface, appMode: mode), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Eyes open, soft surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            vc.navigationController!.pushViewController(MCTSIBViewController(testNumber: MCTSIBTestType.EyesOpenSoftSurface, appMode: mode), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Eyes closed, soft surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            vc.navigationController!.pushViewController(MCTSIBViewController(testNumber: MCTSIBTestType.EyesClosedSoftSurface, appMode: mode), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
}
