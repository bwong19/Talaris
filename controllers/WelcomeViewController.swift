//
//  WelcomeViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/14/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class WelcomeViewController: UIViewController {
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = user
            let ref = Database.database().reference().child("users").child(user.uid).child("first-name")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                self.setupUI(name: "\(snapshot.value ?? "")")
            })
        }
    }
    
    func setupUI(name: String) {
        //        navigationItem.title = "Talaris"
        
        //        let largeTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35)]
        //        let smallTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.KeyNSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        //
        //        navigationController?.navigationBar.largeTitleTextAttributes = largeTextAttributes
        //        navigationController?.navigationBar.titleTextAttributes = smallTextAttributes
        
        //        navigationController?.navigationBar.prefersLargeTitles = true
        //        navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.37, blue:0.72, alpha:1.0)
        //        navigationController?.navigationBar.tintColor = .white
        //        navigationController?.toolbar.barTintColor = UIColor(red:0.00, green:0.37, blue:0.72, alpha:1.0)
        
        let welcomeText = UILabel()
        welcomeText.translatesAutoresizingMaskIntoConstraints = false
        welcomeText.text = "Welcome \(name)!"
        welcomeText.textColor = UIColor(red:0.00, green:146/255, blue:1, alpha:1.0)
        welcomeText.numberOfLines = 0
        welcomeText.textAlignment = .center
        welcomeText.font = UIFont.italicSystemFont(ofSize: 18)
        self.view.addSubview(welcomeText)
        welcomeText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        welcomeText.centerYAnchor.constraint(equalTo:self.view.topAnchor, constant: 150).isActive = true
        welcomeText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        welcomeText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        let conditionText = UILabel()
        conditionText.translatesAutoresizingMaskIntoConstraints = false
        conditionText.text = "Your dynamic gait seems to be improving. Your speed has improved by 20%, your endurance has increased by 12%, and your balance has remained the same."
        conditionText.textColor = UIColor(red:0.00, green:146/255, blue:1, alpha:1.0)
        conditionText.numberOfLines = 0
        conditionText.textAlignment = .center
        conditionText.font = UIFont.italicSystemFont(ofSize: 12)
        self.view.addSubview(conditionText)
        conditionText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        conditionText.centerYAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 20).isActive = true
        conditionText.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        conditionText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        let startButton = UIButton()
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(enterTest), for: .touchUpInside)
        startButton.setTitle("Start Assessment", for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 24)
        startButton.backgroundColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        self.view.addSubview(startButton)
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        startButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 10).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
        
        let scheduleButton = UIButton()
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        //scheduleButton.addTarget(self, action: #selector(enterApp), for: .touchUpInside)
        scheduleButton.setTitle("My Schedule", for: .normal)
        scheduleButton.titleLabel?.font = .systemFont(ofSize: 24)
        scheduleButton.backgroundColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        self.view.addSubview(scheduleButton)
        scheduleButton.centerXAnchor.constraint(equalTo: startButton.centerXAnchor).isActive = true
        scheduleButton.centerYAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 40).isActive = true
        scheduleButton.heightAnchor.constraint(equalToConstant: view.frame.height / 12).isActive = true
        scheduleButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
        
        let profileButton = UIButton()
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        //scheduleButton.addTarget(self, action: #selector(enterApp), for: .touchUpInside)
        profileButton.setTitle("My Profile", for: .normal)
        profileButton.titleLabel?.font = .systemFont(ofSize: 24)
        profileButton.backgroundColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        self.view.addSubview(profileButton)
        profileButton.centerXAnchor.constraint(equalTo: scheduleButton.centerXAnchor).isActive = true
        profileButton.centerYAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 40).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: view.frame.height / 12).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
    }
    
    @objc func enterTest(_ sender : UIButton) {
        self.navigationController!.pushViewController(TestViewController(), animated: true)
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
