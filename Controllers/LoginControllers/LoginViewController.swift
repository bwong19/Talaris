//
//  LoginViewController.swift
//  Talaris
//
//  Created by Taha Baig on 1/14/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import Firebase

// Allows users to login if they haven't logged in before or if they have just logged out
// Skipped over if user is already logged in
class LoginViewController: UIViewController {
    private let emailTextField: UITextField
    private let passwordTextField: UITextField
    
    init() {
        emailTextField = UITextField()
        passwordTextField = UITextField()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // central stackview
        let loginStackView = UIStackView()
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        loginStackView.axis = .vertical
        loginStackView.spacing = 8
        loginStackView.distribution = .fillEqually
        view.addSubview(loginStackView)
        loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -72).isActive = true
        loginStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        loginStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        // app name/logo
        let appLabel = UILabel()
        appLabel.text = "TALARIS HEALTH"
        appLabel.font = UIFont(name: "Ubuntu-Regular", size: 32)
        appLabel.adjustsFontSizeToFitWidth = true
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        appLabel.textAlignment = .center
        appLabel.textColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        loginStackView.addArrangedSubview(appLabel)
        
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
        loginStackView.addArrangedSubview(emailTextField)
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
        loginStackView.addArrangedSubview(passwordTextField)
        passwordTextField.heightAnchor.constraint(equalToConstant: 0.05 * view.frame.height).isActive = true
        
        // central stackview
        let loginButtonsStackView = UIStackView()
        loginButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        loginButtonsStackView.axis = .vertical
        loginButtonsStackView.spacing = 8
        loginButtonsStackView.distribution = .fillEqually
        view.addSubview(loginButtonsStackView)
        loginButtonsStackView.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 8).isActive = true
        loginButtonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
        loginButtonsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        loginButtonsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        // login button
        let loginButton = CustomButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 16)
        loginButton.backgroundColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        loginButton.layer.cornerRadius = 14
        loginButtonsStackView.addArrangedSubview(loginButton)
        
        // signup button
        let signupButton = CustomButton()
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 16)
        signupButton.backgroundColor = UIColor(red: 1/255, green: 48/255, blue: 63/255, alpha: 1)
        signupButton.layer.cornerRadius = 14
        loginButtonsStackView.addArrangedSubview(signupButton)
        
        // trial button
        let trialButton = CustomButton()
        trialButton.translatesAutoresizingMaskIntoConstraints = false
        trialButton.addTarget(self, action: #selector(trial), for: .touchUpInside)
        trialButton.setTitle("Clinical Trial", for: .normal)
        trialButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 16)
        trialButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        trialButton.layer.cornerRadius = 14
        loginButtonsStackView.addArrangedSubview(trialButton)
    }
    
    @objc private func login() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { user, error in
            if user != nil {
                self.navigationController!.pushViewController(CareKitTabsViewController(user: user!.user), animated: true)
            } else {
                let message = error?.localizedDescription
                let alert = UIAlertController(title: "Sign in Error", message: message, preferredStyle : .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @objc private func signup() {
        self.navigationController!.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc private func trial() {
        self.navigationController!.pushViewController(SubjectInfoViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }


}
