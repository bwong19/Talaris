//
//  CheckViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import CareKit

// Displays results of test after completion. Validates whether user performed test correctly and saves data on server if they did.
class CheckViewController: UIViewController {
    private let carePlanStoreManager = CarePlanStoreManager.sharedCarePlanStoreManager

    private let message: String
    private let resultsDict: Dictionary<String, Any>?
    private let motionTracker: MotionTracker?
    private let testType: String?
    
    init(message: String) {
        self.message = message
        resultsDict = nil
        motionTracker = nil
        testType = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    init(message: String, resultsDict: Dictionary<String, Any>, motionTracker: MotionTracker, testType: String) {
        self.message = message
        self.resultsDict = resultsDict
        self.motionTracker = motionTracker
        self.testType = testType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        // display results time
        let statusText = UILabel()
        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusText.adjustsFontSizeToFitWidth = true
        statusText.text = message
        statusText.textColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        statusText.numberOfLines = 0
        statusText.textAlignment = .center
        statusText.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(statusText)
        statusText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        statusText.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        statusText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        statusText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        let yesNoStackView = UIStackView()
        yesNoStackView.translatesAutoresizingMaskIntoConstraints = false
        yesNoStackView.axis = .vertical
        yesNoStackView.spacing = 10
        yesNoStackView.distribution = .fillEqually
        view.addSubview(yesNoStackView)
        yesNoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        yesNoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        yesNoStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        yesNoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        // yes button
        let yesButton = CustomButton()
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addTarget(self, action: #selector(handleSuccesfulTest), for: .touchUpInside)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        yesButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        yesButton.layer.cornerRadius = 10
        yesNoStackView.addArrangedSubview(yesButton)
        
        // no button
        let noButton = CustomButton()
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.addTarget(self, action: #selector(goToHomeScreen), for: .touchUpInside)
        noButton.setTitle("No", for: .normal)
        noButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        noButton.backgroundColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        noButton.layer.cornerRadius = 10
        yesNoStackView.addArrangedSubview(noButton)
        
        let questionText = UILabel()
        questionText.translatesAutoresizingMaskIntoConstraints = false
        questionText.text = "Was the test completed properly?"
        questionText.textColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        questionText.numberOfLines = 0
        questionText.textAlignment = .center
        questionText.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(questionText)
        questionText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        questionText.topAnchor.constraint(equalTo: yesNoStackView.topAnchor, constant: -80).isActive = true
        questionText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        questionText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
    }
    
    @objc private func handleSuccesfulTest() {
        if let motionTracker = motionTracker {
            let alert = UIAlertController(title: "Test Completion", message: "Please provide the test name", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0]
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
    
    private func updateWithResultsAndReturn() {
        let event = CareKitTabsViewController.gaitTrackerViewController?.lastSelectedAssessmentEvent
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
    
   @objc private func goToHomeScreen() {
        if let navController = navigationController {
            for controller in navController.viewControllers {
                if controller is CareKitTabsViewController {
                    navController.popToViewController(controller, animated:true)
                    break
                }
            }
        }
    }

}
