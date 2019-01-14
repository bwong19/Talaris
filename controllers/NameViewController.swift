//
//  TestViewController.swift
//  Talaris
//
//  Created by Taha Baig on 1/14/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            
            let ref = Database.database().reference().child("users").child(user.uid).child("first-name")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                self.navigationItem.title = "Hello \(snapshot.value ?? "")!"
            })
            
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
