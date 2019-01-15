//
//  CheckViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/15/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        let yesNoStackView = UIStackView()
        yesNoStackView.translatesAutoresizingMaskIntoConstraints = false
        yesNoStackView.axis = .vertical
        yesNoStackView.spacing = 10
        yesNoStackView.distribution = .fillEqually
        self.view.addSubview(yesNoStackView)
        yesNoStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        yesNoStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        yesNoStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        yesNoStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        let yesButton = CustomButton()
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        yesButton.setTitle("Yes", for: .normal)
        yesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        yesButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        yesButton.layer.cornerRadius = 10
        yesNoStackView.addArrangedSubview(yesButton)
        
        // no button
        let noButton = CustomButton()
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.addTarget(self, action: #selector(restart), for: .touchUpInside)
        noButton.setTitle("No", for: .normal)
        noButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        noButton.backgroundColor = UIColor(red: 182/255, green: 223/255, blue: 1, alpha: 1)
        noButton.layer.cornerRadius = 10
        yesNoStackView.addArrangedSubview(noButton)
        
    }
    
    @objc func backToHome() {
        self.navigationController!.pushViewController(WelcomeViewController(), animated: true)
    }
    
    @objc func restart() {
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
