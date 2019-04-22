//
//  CareKitTabsViewController.swift
//  Talaris
//
//  Created by Taha Baig on 4/22/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import CareKit

class CareKitTabsViewController: UITabBarController, OCKSymptomTrackerViewControllerDelegate, UITabBarControllerDelegate
 {
    fileprivate let carePlanStoreManager = CarePlanStoreManager.sharedCarePlanStoreManager
    fileprivate let carePlanData: CarePlanData
    static var gaitTrackerViewController : OCKSymptomTrackerViewController? = nil

    required init?(coder aDecoder: NSCoder) {
        carePlanData = CarePlanData(carePlanStore: carePlanStoreManager.store)
        super.init(coder: aDecoder)
    }
    
    public init() {
        carePlanData = CarePlanData(carePlanStore: carePlanStoreManager.store)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        let gaitTrackerStack = createGaitTrackerStack()
        let profileStack = createProfileStack()
        let connectStack = createConnectStack()
        
        self.viewControllers = [gaitTrackerStack, profileStack, connectStack]
        self.title = self.selectedViewController?.tabBarItem.title
    }
    
    fileprivate func createGaitTrackerStack() -> UIViewController {
        let viewController = OCKSymptomTrackerViewController(carePlanStore: carePlanStoreManager.store)
        CareKitTabsViewController.gaitTrackerViewController = viewController
        viewController.delegate = self
        viewController.glyphType = .custom
        viewController.customGlyphImageName = "tug"
        viewController.glyphTintColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        viewController.tabBarItem = UITabBarItem(title: "Gait Tracker", image: UIImage(named: "walking"), selectedImage: UIImage.init(named: "walking"))
        
        return viewController
    }
    
    fileprivate func createProfileStack() -> UIViewController {
        let viewController = UIViewController()
        
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage.init(named: "profile"))
        return viewController
    }
    
    fileprivate func createConnectStack() -> UIViewController {
        let viewController = UIViewController()
        
        viewController.tabBarItem = UITabBarItem(title: "Connect", image: UIImage(named: "Connect-OFF"), selectedImage: UIImage.init(named: "Connect-ON"))
        return viewController
    }
    
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        switch assessmentEvent.activity.identifier {
            case "Timed Up and Go":
                self.navigationController!.pushViewController(TUGViewController(), animated: true)
            case "Six Minute Walk Test":
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Six Minute Walk Test", message: "Please provide the distance from your starting position to the turnaround point (in meters)", preferredStyle: .alert)
                
                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.text = ""
                }
                
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                    self.navigationController!.pushViewController(SIXMWTViewController(turnaroundDistance: Double(textField.text!)!), animated: true)
                }))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            case "Sway Test":
                self.navigationController!.pushViewController(MCTSIBViewController(), animated: true)
            default:
                print("error")
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }

}
