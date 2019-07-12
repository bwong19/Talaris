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
    
    private let firstNameTextField: UITextField
    private let lastNameTextField: UITextField
    
    init() {
        ref = Database.database().reference()
        
        firstNameTextField = UITextField()
        lastNameTextField = UITextField()
        
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
        
        // first name input
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.adjustsFontSizeToFitWidth = true
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.textAlignment = .left
        firstNameTextField.layer.borderColor = UIColor.gray.cgColor
        firstNameTextField.layer.borderWidth = 1.0
        firstNameTextField.layer.cornerRadius = 5.0
        firstNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        infoStackView.addArrangedSubview(firstNameTextField)
        firstNameTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height).isActive = true
        
        // last name input
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.adjustsFontSizeToFitWidth = true
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.textAlignment = .left
        lastNameTextField.layer.borderColor = UIColor.gray.cgColor
        lastNameTextField.layer.borderWidth = 1.0
        lastNameTextField.layer.cornerRadius = 5.0
        lastNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        infoStackView.addArrangedSubview(lastNameTextField)
        lastNameTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height).isActive = true
        
        // next button
        let nextButton = CustomButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nextButton.backgroundColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        nextButton.layer.cornerRadius = 10
        infoStackView.addArrangedSubview(nextButton)
    }
    
    @objc private func nextScreen() {
        /*
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { user, error in
            if user != nil {
                let userRef = self.ref.child("users").child(user!.user.uid)
                userRef.child("first-name").setValue(self.firstNameTextField.text!)
                userRef.child("last-name").setValue(self.lastNameTextField.text!)
                
                Auth.auth().signIn(withEmail: self.emailTextField.text!,
                                   password: self.passwordTextField.text!)
                
                self.navigationController!.pushViewController(CareKitTabsViewController(user: user!.user), animated: true)
            } else {
                let message = error?.localizedDescription
                let alert = UIAlertController(title: "Sign up Error", message: message, preferredStyle : .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        */
        self.navigationController!.pushViewController(ClinicalTrialTestViewController(), animated: true)
    }
}
