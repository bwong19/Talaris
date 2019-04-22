//
//  CheckAuthViewController.swift
//  Talaris
//
//  Created by Taha Baig on 1/25/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import Firebase

class CheckAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.navigationController!.pushViewController(CareKitTabsViewController(), animated: false)
            } else {
                self.navigationController!.pushViewController(LoginViewController(), animated: false)
            }
        }
        
        
        // Do any additional setup after loading the view.
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
