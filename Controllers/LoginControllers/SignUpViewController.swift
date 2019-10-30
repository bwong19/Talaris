//
//  SignUpViewController.swift
//  Talaris
//
//  Created by Taha Baig on 1/14/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

// Allows users to create a new account and login
class SignUpViewController: UIViewController {
    private let ref: DatabaseReference
    
    private let emailTextField: UITextField
    private let passwordTextField: UITextField
    private let firstNameTextField: UITextField
    private let lastNameTextField: UITextField
    
    init() {
        ref = Database.database().reference()
        
        emailTextField = UITextField()
        passwordTextField = UITextField()
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
        navigationItem.title = "Sign Up"

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // central stackview
        let signupStackView = UIStackView()
        signupStackView.translatesAutoresizingMaskIntoConstraints = false
        signupStackView.axis = .vertical
        signupStackView.spacing = 10
        signupStackView.distribution = .fillEqually
        view.addSubview(signupStackView)
        signupStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        signupStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        signupStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        signupStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        // email input
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = "Email"
        emailTextField.font = UIFont(name: "Ubuntu-Regular", size: 16)
        emailTextField.textAlignment = .left
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        signupStackView.addArrangedSubview(emailTextField)
        emailTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height).isActive = true
        
        // password input
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont(name: "Ubuntu-Regular", size: 16)
        passwordTextField.textAlignment = .left
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 5.0
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        signupStackView.addArrangedSubview(passwordTextField)
        passwordTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height).isActive = true
        
        // first name input
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.adjustsFontSizeToFitWidth = true
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.font = UIFont(name: "Ubuntu-Regular", size: 16)
        firstNameTextField.textAlignment = .left
        firstNameTextField.layer.borderColor = UIColor.gray.cgColor
        firstNameTextField.layer.borderWidth = 1.0
        firstNameTextField.layer.cornerRadius = 5.0
        firstNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        signupStackView.addArrangedSubview(firstNameTextField)
        firstNameTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height).isActive = true
        
        // last name input
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.adjustsFontSizeToFitWidth = true
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.font = UIFont(name: "Ubuntu-Regular", size: 16)
        lastNameTextField.textAlignment = .left
        lastNameTextField.layer.borderColor = UIColor.gray.cgColor
        lastNameTextField.layer.borderWidth = 1.0
        lastNameTextField.layer.cornerRadius = 5.0
        lastNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        signupStackView.addArrangedSubview(lastNameTextField)
        lastNameTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height).isActive = true
        
        // signup button
        let signupButton = CustomButton()
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 16)
        signupButton.backgroundColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        signupButton.layer.cornerRadius = 10
        signupStackView.addArrangedSubview(signupButton)
    }
    
    @objc private func signup() {
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
    }

}

