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

class SignUpViewController: UIViewController {
    var ref : DatabaseReference!
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Sign Up"
        self.ref = Database.database().reference()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // central stackview
        let signupStackView = UIStackView()
        signupStackView.translatesAutoresizingMaskIntoConstraints = false
        signupStackView.axis = .vertical
        signupStackView.spacing = 10
        signupStackView.distribution = .fillEqually
        self.view.addSubview(signupStackView)
        signupStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        signupStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        signupStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        signupStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        // email input
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.keyboardType = .emailAddress
        emailTextField.placeholder = "Email"
        emailTextField.textAlignment = .left
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        signupStackView.addArrangedSubview(emailTextField)
        emailTextField.heightAnchor.constraint(equalToConstant: 0.05 * self.view.frame.height).isActive = true
        
        // password input
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.textAlignment = .left
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 5.0
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        signupStackView.addArrangedSubview(passwordTextField)
        passwordTextField.heightAnchor.constraint(equalToConstant: 0.05 * self.view.frame.height).isActive = true
        
        // first name input
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.adjustsFontSizeToFitWidth = true
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.textAlignment = .left
        firstNameTextField.layer.borderColor = UIColor.gray.cgColor
        firstNameTextField.layer.borderWidth = 1.0
        firstNameTextField.layer.cornerRadius = 5.0
        firstNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        signupStackView.addArrangedSubview(firstNameTextField)
        firstNameTextField.heightAnchor.constraint(equalToConstant: 0.05 * self.view.frame.height).isActive = true
        
        // last name input
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.adjustsFontSizeToFitWidth = true
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.textAlignment = .left
        lastNameTextField.layer.borderColor = UIColor.gray.cgColor
        lastNameTextField.layer.borderWidth = 1.0
        lastNameTextField.layer.cornerRadius = 5.0
        lastNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        signupStackView.addArrangedSubview(lastNameTextField)
        lastNameTextField.heightAnchor.constraint(equalToConstant: 0.05 * self.view.frame.height).isActive = true
        
        // signup button
        let signupButton = CustomButton()
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signupButton.backgroundColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        signupButton.layer.cornerRadius = 10
        signupStackView.addArrangedSubview(signupButton)
    }
    
    @objc func signup() {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { user, error in
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
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

