//
//  CheckAuthViewController.swift
//  Talaris
//
//  Created by Taha Baig on 1/25/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import Firebase

// Determines if user is already logged in or not, if yes then navigates user to home screen of app, otherwise to login screen
class CheckAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.navigationController!.pushViewController(CareKitTabsViewController(user:user!), animated: false)
            } else {
                self.navigationController!.pushViewController(LoginViewController(), animated: false)
            }
        }
    }
    
}
