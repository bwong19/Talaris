//
//  GaitAlert.swift
//  Talaris
//
//  Created by Brandon Wong on 10/1/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import Foundation
import UIKit

// sets up alerts for each type of gait test
class GaitAlert {
    
    class func tugAlert(in vc: UIViewController, mode: AppMode, delegate: GaitTestDelegate? = nil) {
        vc.navigationController!.pushViewController(TUGViewController(appMode: mode, delegate: delegate), animated: true)
    }
    
    class func sixmwtAlert(in vc: UIViewController, mode: AppMode, delegate: GaitTestDelegate? = nil){
        let alert = UIAlertController(title: "Two Minute Walk Test", message: "Please provide the distance from your starting position to the turnaround point (in meters).", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Distance"
            textField.text = "30"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            let distance : Double = Double(textField.text!) ?? 30
            vc.navigationController!.pushViewController(
                SIXMWTViewController(
                    turnaroundDistance: distance,
                    appMode: mode,
                    delegate: delegate
                ),
                animated: true
            )
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func mctsibAlert(in vc: UIViewController, mode: AppMode, delegate: GaitTestDelegate? = nil) {
        let alert = UIAlertController(title: "MCTSIB", message: "Please select a pose.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Eyes open, firm surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            handleMctsibAlertAction(vc: vc, mctsibTestType: MCTSIBTestType.EyesOpenFirmSurface, mode: mode, delegate: delegate)
        }))
        alert.addAction(UIAlertAction(title: "Eyes closed, firm surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            handleMctsibAlertAction(vc: vc, mctsibTestType: MCTSIBTestType.EyesClosedFirmSurface, mode: mode, delegate: delegate)
        }))
        alert.addAction(UIAlertAction(title: "Eyes open, soft surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            handleMctsibAlertAction(vc: vc, mctsibTestType: MCTSIBTestType.EyesOpenSoftSurface, mode: mode, delegate: delegate)
        }))
        alert.addAction(UIAlertAction(title: "Eyes closed, soft surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            handleMctsibAlertAction(vc: vc, mctsibTestType: MCTSIBTestType.EyesClosedSoftSurface, mode: mode, delegate: delegate)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    private class func handleMctsibAlertAction(vc: UIViewController, mctsibTestType: MCTSIBTestType, mode: AppMode, delegate: GaitTestDelegate?) {
        vc.navigationController!.pushViewController(
            MCTSIBViewController(testNumber: mctsibTestType, appMode: mode, delegate: delegate), animated: true
        )
    }
}
