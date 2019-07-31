//
//  CareKitTabsViewController.swift
//  Talaris
//
//  Created by Taha Baig on 4/22/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import CareKit
import Firebase
import FirebaseDatabase


class CareKitTabsViewController: UITabBarController, OCKSymptomTrackerViewControllerDelegate, UITabBarControllerDelegate
 {
    private let carePlanStoreManager = CarePlanStoreManager.sharedCarePlanStoreManager
    private let carePlanData: CarePlanData
    private let ref: DatabaseReference
    
    // used to access field 'lastSelectedAssessmentEvent' in CheckViewController in order to save that a test has been finished
    // TODO: refactor to avoid this 'hidden' dependency (As it's not explicitly passed into CheckViewController, but still required)
    static var gaitTrackerViewController : OCKSymptomTrackerViewController?
    
    private let user: User
    
    public init(user: User) {
        carePlanData = CarePlanData(carePlanStore: carePlanStoreManager.store)
        ref = Database.database().reference()
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true

        let userInfoRef = ref.child("users").child(user.uid)
        userInfoRef.observeSingleEvent(of: .value, with: { snapshot in
            let userNameInfo = snapshot.value as! Dictionary<String, String>
            let gaitTrackerStack = self.createGaitTrackerStack()
            let profileStack = self.createProfileStack()
            let connectStack = self.createConnectStack(userInfo: userNameInfo)
            let settingsStack = self.createSettingsStack()
            
            let tabBarList = [gaitTrackerStack, profileStack, connectStack, settingsStack]
            
            self.viewControllers = tabBarList.map {
                UINavigationController(rootViewController: $0)
            }
            
            self.title = self.selectedViewController?.tabBarItem.title
        })
    }
    
    private func createGaitTrackerStack() -> UIViewController {
        let viewController = OCKSymptomTrackerViewController(carePlanStore: carePlanStoreManager.store)
        CareKitTabsViewController.gaitTrackerViewController = viewController
        viewController.delegate = self
        viewController.glyphType = .custom
        viewController.customGlyphImageName = "tug"
        viewController.glyphTintColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        viewController.tabBarItem = UITabBarItem(title: "Gait Tracker", image: UIImage(named: "walking"), selectedImage: UIImage.init(named: "walking"))
        
        return viewController
    }
    
    private func createProfileStack() -> UIViewController {
        let viewController = MetricGraphsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage.init(named: "profile"))
        return viewController
    }
    
    private func createConnectStack(userInfo: Dictionary<String, Any>) -> UIViewController {
        let viewController = OCKConnectViewController(contacts: carePlanData.contacts)
        
        let firstName: String = userInfo["first-name"] as! String
        let lastName: String = userInfo["last-name"] as! String
        let fullName = "\(firstName) \(lastName)"
        let monogram = "\(firstName.prefix(1))\(lastName.prefix(1))"
        
        viewController.patient = OCKPatient(identifier: fullName, carePlanStore: carePlanStoreManager.store, name: fullName, detailInfo: nil, careTeamContacts: nil, tintColor: nil, monogram: monogram, image: nil, categories: nil, userInfo: nil)
        viewController.tabBarItem = UITabBarItem(title: "Connect", image: UIImage(named: "Connect-OFF"), selectedImage: UIImage.init(named: "Connect-ON"))
        return viewController
    }
    
    private func createSettingsStack() -> UIViewController {
        let viewController = SettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings-1"), selectedImage: UIImage.init(named: "Settings-1"))
        return viewController
    }
    
    func symptomTrackerViewController(_ viewController: OCKSymptomTrackerViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
        switch assessmentEvent.activity.identifier {
            case "Timed Up and Go":
                navigationController!.pushViewController(TUGViewController(), animated: true)
            case "Six Minute Walk Test":
                let alert = UIAlertController(title: "Six Minute Walk Test", message: "Please provide the distance from your starting position to the turnaround point (in meters)", preferredStyle: .alert)
                
                alert.addTextField { (textField) in
                    textField.text = ""
                }
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert!.textFields![0]
                    self.navigationController!.pushViewController(SIXMWTViewController(turnaroundDistance: Double(textField.text!)!), animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
            case "Sway Test":
                let alert = UIAlertController(title: "MCTSIB", message: "Please select a pose", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Eyes open, firm surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    self.navigationController!.pushViewController(MCTSIBViewController(testNumber: 0), animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Eyes closed, firm surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    self.navigationController!.pushViewController(MCTSIBViewController(testNumber: 1), animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Eyes open, soft surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    self.navigationController!.pushViewController(MCTSIBViewController(testNumber: 2), animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Eyes closed, soft surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    self.navigationController!.pushViewController(MCTSIBViewController(testNumber: 3), animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            default:
                print("error")
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        title = item.title
    }

}
