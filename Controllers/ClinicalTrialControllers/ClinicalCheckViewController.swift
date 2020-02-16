//
//  ClinicalCheckViewController.swift
//  Talaris
//
//  Created by Brandon Wong on 9/21/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit

class ClinicalCheckViewController: UIViewController {

    private let message: String
    private let resultsDict: Dictionary<String, Any>
    private let motionTracker: MotionTracker
    private let gaitTestType: GaitTestType
    private let subjectID: String
    
    init(message: String, resultsDict: Dictionary<String, Any>, motionTracker: MotionTracker, gaitTestType: GaitTestType, subjectID: String) {
        self.message = message
        self.resultsDict = resultsDict
        self.motionTracker = motionTracker
        self.gaitTestType = gaitTestType
        self.subjectID = subjectID
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
        statusText.textColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        statusText.numberOfLines = 0
        statusText.textAlignment = .center
        statusText.font = UIFont(name: "Ubuntu-Regular", size: 32)
        view.addSubview(statusText)
        statusText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        statusText.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        statusText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        statusText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
         
        let yesNoStackView = UIStackView()
        yesNoStackView.translatesAutoresizingMaskIntoConstraints = false
        yesNoStackView.axis = .vertical
        yesNoStackView.spacing = 8
        yesNoStackView.distribution = .fillEqually
        view.addSubview(yesNoStackView)
        yesNoStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 249).isActive = true
        yesNoStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
        yesNoStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        yesNoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
         
        // yes button
        let yesButton = CustomButton()
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addTarget(self, action: #selector(handleSuccessfulTest), for: .touchUpInside)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        yesButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        yesButton.layer.cornerRadius = 14
        yesNoStackView.addArrangedSubview(yesButton)
        
        // no button
        let noButton = CustomButton()
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.addTarget(self, action: #selector(handleUnsuccessfulTest), for: .touchUpInside)
        noButton.setTitle("No", for: .normal)
        noButton.titleLabel?.font = UIFont(name: "Ubuntu-Regular", size: 32)
        noButton.backgroundColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        noButton.layer.cornerRadius = 14
        yesNoStackView.addArrangedSubview(noButton)
        
        let questionText = UILabel()
        questionText.translatesAutoresizingMaskIntoConstraints = false
        questionText.adjustsFontSizeToFitWidth = true
        questionText.text = "Was the test completed properly?"
        questionText.textColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        questionText.font = UIFont(name: "Ubuntu-Regular", size: 32)
        questionText.numberOfLines = 0
        questionText.textAlignment = .center
        view.addSubview(questionText)
        questionText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        questionText.topAnchor.constraint(equalTo: yesNoStackView.topAnchor, constant: -70).isActive = true
        questionText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        questionText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
    }
     
    @objc private func handleSuccessfulTest() {
        let alert = UIAlertController(title: "Test Completion", message: "Please provide the test name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            let textFieldText = (textField.text != nil && textField.text != "") ? textField.text! + "_" : ""
            let fileSuffix = "SubjectId-\(self.subjectID)_\(self.gaitTestType)"
            self.motionTracker.saveAndClearData(
                testName: "\(textFieldText)\(fileSuffix)",
                testMode: AppMode.Clinical,
                testResults: self.resultsDict
            )
            
            DispatchQueue.main.async {
                self.goToHomeScreen()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func handleUnsuccessfulTest() {
        let alert = UIAlertController(title: "Unsaved Data", message: "Are you sure you want to exit without saving data?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) -> Void in
            DispatchQueue.main.async {
                self.goToHomeScreen()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
     
    @objc private func goToHomeScreen() {
        if let navController = navigationController {
            for controller in navController.viewControllers {
                if controller is ClinicalTrialTestViewController {
                    navController.popToViewController(controller, animated:true)
                    break
                }
            }
        }
    }


}
