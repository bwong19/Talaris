//
//  ClinicalTrialTestViewController.swift
//  Talaris
//
//  Created by Brandon Wong on 7/10/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit

// class for clinical trials only
// skips user login
class ClinicalTrialTestViewController: UIViewController {
    
    private let subjectID: String
    
    init(subjectID: String) {
        self.subjectID = subjectID
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
        let trialStackView = UIStackView()
        trialStackView.translatesAutoresizingMaskIntoConstraints = false
        trialStackView.axis = .vertical
        trialStackView.spacing = 8
        trialStackView.distribution = .fillEqually
        view.addSubview(trialStackView)
        trialStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
        trialStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
        trialStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        trialStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        // TUG Test button
        let tugButton = CustomButton()
        tugButton.translatesAutoresizingMaskIntoConstraints = false
        tugButton.addTarget(self, action: #selector(tug), for: .touchUpInside)
        tugButton.setTitle("TUG Test", for: .normal)
        tugButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        tugButton.backgroundColor = UIColor(red: 1/255, green: 48/255, blue: 63/255, alpha: 1)
        tugButton.layer.cornerRadius = 14
        trialStackView.addArrangedSubview(tugButton)
        
        // 6MWT button
        let sixmwtButton = CustomButton()
        sixmwtButton.translatesAutoresizingMaskIntoConstraints = false
        sixmwtButton.addTarget(self, action: #selector(sixmwt), for: .touchUpInside)
        sixmwtButton.setTitle("2MWT", for: .normal)
        sixmwtButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        sixmwtButton.backgroundColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        sixmwtButton.layer.cornerRadius = 14
        trialStackView.addArrangedSubview(sixmwtButton)
        
        // mCTSIB button
        let mctsibButton = CustomButton()
        mctsibButton.translatesAutoresizingMaskIntoConstraints = false
        mctsibButton.addTarget(self, action: #selector(mctsib), for: .touchUpInside)
        mctsibButton.setTitle("mCTSIB", for: .normal)
        mctsibButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        mctsibButton.backgroundColor = UIColor(red: 120/255, green: 214/255, blue: 255/255, alpha: 1)
        mctsibButton.layer.cornerRadius = 14
        trialStackView.addArrangedSubview(mctsibButton)
        
        // finish button
        let finishButton = CustomButton()
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.addTarget(self, action: #selector(finish), for: .touchUpInside)
        finishButton.setTitle("Finish", for: .normal)
        finishButton.titleLabel?.font = UIFont(name: "Ubuntu-Regular", size: 24)
        finishButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        finishButton.layer.cornerRadius = 14
        view.addSubview(finishButton)
        finishButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -64).isActive = true
        finishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        finishButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        finishButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
    }
    
    @objc private func tug() {
        GaitAlert.tugAlert(in: self, mode: AppMode.Clinical, delegate: self as! GaitTestDelegate)
    }
    
    @objc private func sixmwt() {
        GaitAlert.sixmwtAlert(in: self, mode: AppMode.Clinical, delegate: self as! GaitTestDelegate)
    }
    
    @objc private func mctsib() {
        GaitAlert.mctsibAlert(in: self, mode: AppMode.Clinical, delegate: self as! GaitTestDelegate)
    }
    
    @objc private func finish() {
        self.navigationController!.pushViewController(CompletedViewController(), animated: true)
    }
}
