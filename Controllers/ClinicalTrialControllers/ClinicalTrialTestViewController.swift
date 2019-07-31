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
    
    private var sixmwtCounter = 0
    private var tugCounter = 0
    private var mctsibCounter = 0
    
    init() {
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
        
        // 6MWT button
        let sixmwtButton = CustomButton()
        sixmwtButton.translatesAutoresizingMaskIntoConstraints = false
        sixmwtButton.addTarget(self, action: #selector(sixmwt), for: .touchUpInside)
        sixmwtButton.setTitle(String(format: "6MWT: %d/3", sixmwtCounter), for: .normal)
        sixmwtButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        sixmwtButton.backgroundColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        sixmwtButton.layer.cornerRadius = 14
        trialStackView.addArrangedSubview(sixmwtButton)
        
        // TUG Test button
        let tugButton = CustomButton()
        tugButton.translatesAutoresizingMaskIntoConstraints = false
        tugButton.addTarget(self, action: #selector(tug), for: .touchUpInside)
        tugButton.setTitle(String(format: "TUG Test: %d/3", tugCounter), for: .normal)
        tugButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        tugButton.backgroundColor = UIColor(red: 120/255, green: 214/255, blue: 255/255, alpha: 1)
        tugButton.layer.cornerRadius = 14
        trialStackView.addArrangedSubview(tugButton)
        
        // mCTSIB button
        let mctsibButton = CustomButton()
        mctsibButton.translatesAutoresizingMaskIntoConstraints = false
        mctsibButton.addTarget(self, action: #selector(mctsib), for: .touchUpInside)
        mctsibButton.setTitle(String(format: "mCTSIB: %d/1", mctsibCounter), for: .normal)
        mctsibButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        mctsibButton.backgroundColor = UIColor(red: 1/255, green: 48/255, blue: 63/255, alpha: 1)
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
    
    func incrementTestCounter(testType: String) {
        switch (testType) {
        case "6MWT":
            self.sixmwtCounter += 1;
            break;
        case "TUG":
            self.tugCounter += 1;
            break;
        case "MCTSIB":
            self.mctsibCounter += 1;
            break;
        default:
            break;
        }
    }
    
    func isCompleted() -> Bool {
        if sixmwtCounter == 3 && tugCounter == 3 && mctsibCounter == 1 {
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
        
        // 6MWT button
        let sixmwtButton = CustomButton()
        sixmwtButton.translatesAutoresizingMaskIntoConstraints = false
        sixmwtButton.addTarget(self, action: #selector(sixmwt), for: .touchUpInside)
        sixmwtButton.setTitle(String(format: "6MWT: %d/3", sixmwtCounter), for: .normal)
        sixmwtButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        sixmwtButton.backgroundColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        sixmwtButton.layer.cornerRadius = 14
        trialStackView.addArrangedSubview(sixmwtButton)
        
        // TUG Test button
        let tugButton = CustomButton()
        tugButton.translatesAutoresizingMaskIntoConstraints = false
        tugButton.addTarget(self, action: #selector(tug), for: .touchUpInside)
        tugButton.setTitle(String(format: "TUG Test: %d/3", tugCounter), for: .normal)
        tugButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        tugButton.backgroundColor = UIColor(red: 120/255, green: 214/255, blue: 255/255, alpha: 1)
        tugButton.layer.cornerRadius = 14
        trialStackView.addArrangedSubview(tugButton)
        
        // mCTSIB button
        let mctsibButton = CustomButton()
        mctsibButton.translatesAutoresizingMaskIntoConstraints = false
        mctsibButton.addTarget(self, action: #selector(mctsib), for: .touchUpInside)
        mctsibButton.setTitle(String(format: "mCTSIB: %d/1", mctsibCounter), for: .normal)
        mctsibButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 32)
        mctsibButton.backgroundColor = UIColor(red: 1/255, green: 48/255, blue: 63/255, alpha: 1)
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
    
    @objc private func sixmwt() {
        let alert = UIAlertController(title: "Six Minute Walk Test", message: "Please provide the distance from your starting position to the turnaround point (in meters)", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.navigationController!.pushViewController(SIXMWTViewController(turnaroundDistance: Double(textField.text!)!), animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func tug() {
        self.navigationController!.pushViewController(TUGViewController(), animated: true)
    }
    
    @objc private func mctsib() {
        let alert = UIAlertController(title: "MCTSIB", message: "Please select a pose", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Eyes open, firm surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.navigationController!.pushViewController(MCTSIBViewController(testNumber: 0), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Eyes closed, firm surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.navigationController!.pushViewController(MCTSIBViewController(testNumber: 1), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Eyes open, soft surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.navigationController!.pushViewController(MCTSIBViewController(testNumber: 2), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Eyes closed, soft surface", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.navigationController!.pushViewController(MCTSIBViewController(testNumber: 3), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func finish() {
        self.navigationController!.pushViewController(CompletedViewController(), animated: true)
    }
}
