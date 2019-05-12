//
//  SettingsViewController.swift
//  Talaris
//
//  Created by Taha Baig on 4/22/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // logout button
        let logoutButton = CustomButton()
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 24)
        logoutButton.backgroundColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        logoutButton.layer.cornerRadius = 10
        view.addSubview(logoutButton)
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
    }
    
    @objc private func logout(_ sender : UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }

}
