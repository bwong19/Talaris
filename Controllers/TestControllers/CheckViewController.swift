//
//  CheckViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import CareKit

class CheckViewController: UIViewController {
    
    var message: String?
    var motionTracker : MotionTracker?
    var testType : String?
    var resultsDict : Dictionary<String, Any>?
    fileprivate let carePlanStoreManager = CarePlanStoreManager.sharedCarePlanStoreManager
    
    public init(message: String, resultsDict : Dictionary<String, Any>? = nil, motionTracker : MotionTracker? = nil, testType : String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.message = message
        self.resultsDict = resultsDict
        self.motionTracker = motionTracker
        self.testType = testType
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        // display results time
        let statusText = UILabel()
        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusText.adjustsFontSizeToFitWidth = true
        statusText.text = message
        statusText.textColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        statusText.numberOfLines = 0
        statusText.textAlignment = .center
        statusText.font = UIFont.systemFont(ofSize: 24)
        self.view.addSubview(statusText)
        statusText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        statusText.centerYAnchor.constraint(equalTo:self.view.topAnchor, constant: 150).isActive = true
        statusText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        statusText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        let yesNoStackView = UIStackView()
        yesNoStackView.translatesAutoresizingMaskIntoConstraints = false
        yesNoStackView.axis = .vertical
        yesNoStackView.spacing = 10
        yesNoStackView.distribution = .fillEqually
        self.view.addSubview(yesNoStackView)
        yesNoStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        yesNoStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        yesNoStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        yesNoStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        // yes button
        let yesButton = CustomButton()
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        yesButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        yesButton.layer.cornerRadius = 10
        yesNoStackView.addArrangedSubview(yesButton)
        
        // no button
        let noButton = CustomButton()
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.addTarget(self, action: #selector(restart), for: .touchUpInside)
        noButton.setTitle("No", for: .normal)
        noButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        noButton.backgroundColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        noButton.layer.cornerRadius = 10
        yesNoStackView.addArrangedSubview(noButton)
        
        //
        let questionText = UILabel()
        questionText.translatesAutoresizingMaskIntoConstraints = false
        questionText.text = "Was the test completed properly?"
        questionText.textColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        questionText.numberOfLines = 0
        questionText.textAlignment = .center
        questionText.font = UIFont.systemFont(ofSize: 24)
        self.view.addSubview(questionText)
        questionText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        questionText.topAnchor.constraint(equalTo: yesNoStackView.topAnchor, constant: -80).isActive = true
        questionText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        questionText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
    }
    
    @objc func backToHome() {
        if let motionTracker = self.motionTracker {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Test Completion", message: "Please provide the test name", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                motionTracker.saveAndClearData(testName: "\(textField.text ?? "No Name Provided")_\(self.testType!)", testResults: self.resultsDict)
                self.updateWithResultsAndReturn()
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                self.goToHomeScreen()
            }
        }
    }
    
    func updateWithResultsAndReturn() {
        let event = CareKitTabsViewController.gaitTrackerViewController?.lastSelectedAssessmentEvent
        print(event!)
        let carePlanResult = OCKCarePlanEventResult(valueString: "", unitString: "", userInfo: nil)
        carePlanStoreManager.store.update(event!, with: carePlanResult, state: .completed) {
            success, _, error in
            if !success {
                print(error?.localizedDescription ?? "error")
            } else {
                DispatchQueue.main.async {
                    self.goToHomeScreen()
                }
            }
        }
    }
    
    func goToHomeScreen() {
        if let navController = self.navigationController {
            for controller in navController.viewControllers {
                if controller is CareKitTabsViewController {
                    navController.popToViewController(controller, animated:true)
                    break
                }
            }
        }
    }

    @objc func restart() {
        goToHomeScreen()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
