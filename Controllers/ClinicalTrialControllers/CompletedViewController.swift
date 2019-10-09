//
//  CompletedViewController.swift
//  Talaris
//
//  Created by Brandon Wong on 7/17/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit

class CompletedViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        // central stackview
        let completedStackView = UIStackView()
        completedStackView.translatesAutoresizingMaskIntoConstraints = false
        completedStackView.axis = .vertical
        completedStackView.spacing = 10
        completedStackView.distribution = .fillEqually
        view.addSubview(completedStackView)
        completedStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        completedStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        completedStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        completedStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        // display completed status
        let statusText = UILabel()
        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusText.text = "Thank you for using Talaris Clinical!"
        statusText.textColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        statusText.numberOfLines = 0
        statusText.textAlignment = .center
        statusText.font = UIFont(name: "Ubuntu-Regular", size: 24)
        view.addSubview(statusText)
        statusText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        statusText.topAnchor.constraint(equalTo: completedStackView.topAnchor, constant: -80).isActive = true
        statusText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        statusText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        let returnButton = CustomButton()
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        returnButton.addTarget(self, action: #selector(returnToLogin), for: .touchUpInside)
        returnButton.setTitle("Return to login", for: .normal)
        returnButton.titleLabel?.font = UIFont(name: "Ubuntu-Regular", size: 16)
        returnButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        returnButton.layer.cornerRadius = 14
        completedStackView.addArrangedSubview(returnButton)
        
        // returns to trials
        let trialsButton = CustomButton()
        trialsButton.translatesAutoresizingMaskIntoConstraints = false
        trialsButton.addTarget(self, action: #selector(returnToTrials), for: .touchUpInside)
        trialsButton.setTitle("Return to trials", for: .normal)
        trialsButton.titleLabel?.font = UIFont(name: "Ubuntu-Regular", size: 16)
        trialsButton.backgroundColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        trialsButton.layer.cornerRadius = 14
        completedStackView.addArrangedSubview(trialsButton)
    }

    @objc func returnToLogin() {
        if let navController = navigationController {
            var foundLogin = false
            for controller in navController.viewControllers {
                if controller is LoginViewController {
                    navController.popToViewController(controller, animated:true)
                    foundLogin = true
                    break
                }
            }
            if !foundLogin {
                navController.pushViewController(LoginViewController(), animated: true)
            }
        }
    }
    
    @objc func returnToTrials() {
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
