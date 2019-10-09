//
//  SubjectInfoViewController.swift
//  Talaris
//
//  Created by Brandon Wong on 7/12/19.
//  Copyright © 2019 Talaris. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase

// Allows users to create a new account and login
class SubjectInfoViewController: UIViewController {
    private let ref: DatabaseReference
    
    private let subjectIDTextField: UITextField
    
    init() {
        ref = Database.database().reference()
        
        subjectIDTextField = UITextField()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Subject Information"
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // central stackview
        let infoStackView = UIStackView()
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 10
        infoStackView.distribution = .fillEqually
        view.addSubview(infoStackView)
        infoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        infoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        infoStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        infoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        // label
        let appLabel = UILabel()
        appLabel.text = "Enter subject information below"
        appLabel.font = UIFont(name: "Ubuntu-Regular", size: 16)
        appLabel.textColor = UIColor(white: 0.36, alpha: 1)
        appLabel.adjustsFontSizeToFitWidth = true
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        appLabel.textAlignment = .center
        infoStackView.addArrangedSubview(appLabel)
        
        // subject input
        subjectIDTextField.translatesAutoresizingMaskIntoConstraints = false
        subjectIDTextField.adjustsFontSizeToFitWidth = true
        subjectIDTextField.placeholder = "Subject ID"
        subjectIDTextField.font = UIFont(name: "Ubuntu-Regular", size: 16)
        subjectIDTextField.textAlignment = .left
        subjectIDTextField.layer.borderColor = UIColor.gray.cgColor
        subjectIDTextField.layer.borderWidth = 1.0
        subjectIDTextField.layer.cornerRadius = 5.0
        subjectIDTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        infoStackView.addArrangedSubview(subjectIDTextField)
        subjectIDTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height).isActive = true
        
        // next button
        let nextButton = CustomButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 16)
        nextButton.backgroundColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        nextButton.layer.cornerRadius = 10
        infoStackView.addArrangedSubview(nextButton)
    }
    
    @objc private func nextScreen() {
        self.navigationController!.pushViewController(ClinicalTrialTestViewController(), animated: true)
    }
}
