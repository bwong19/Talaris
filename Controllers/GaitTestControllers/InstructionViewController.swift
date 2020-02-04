//
//  InstructionViewController.swift
//  Talaris
//
//  Created by Brandon Wong on 1/23/20.
//  Copyright © 2020 Talaris. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController, GaitTestDelegate {
    let gaitTestType: GaitTestType
    let subjectID: String
    
    private let messages = [
        GaitTestType.TUG: "The Timed-Up and Go test, also known as the TUG test, is a gait assessment used to measure speed. Before you begin the TUG test, please make sure you have placed a chair without wheels in an uncluttered area, and place a cone or marker 3 meters away from it. When you have understood and performed these instructions, please press the 'NEXT' button on the screen. If you want to repeat these instructions, please press the 'REPEAT' button.",
        GaitTestType.SixMWT: "The Two Minute Walk Test measures endurance. Before you begin the test, please make sure you have set up two cones between 12 meters [1] and 30 meters apart. Please wear your regular footwear and use a walking aid, such as a cane or walker, if needed. After you have set up the two cones, please enter the distance between them and press the “NEXT” button on the screen. If you want to replay these instructions, please press the “REPEAT” button.",
        GaitTestType.MCTSIB: "The CTSIB-M is a test used to measure balance. This test will be performed on the Biodex machine, but before you begin, please make sure that the hard surface is placed on the  platform of the machine. When you have understood these instructions, please press the ‘NEXT’ button on the screen. If you want to repeat these instructions, please press the “REPEAT” button."
    ]
    
    init(gaitTestType: GaitTestType, subjectID: String) {
        self.gaitTestType = gaitTestType
        self.subjectID = subjectID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        // display instructions
        let instructionText = UILabel()
        instructionText.translatesAutoresizingMaskIntoConstraints = false
        instructionText.adjustsFontSizeToFitWidth = true
        instructionText.text = messages[gaitTestType]
        instructionText.textColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        instructionText.font = UIFont(name: "Ubuntu-Regular", size: 16)
        instructionText.textAlignment = .justified
        instructionText.numberOfLines = 0
        view.addSubview(instructionText)
        instructionText.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
        instructionText.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 72).isActive = true
        instructionText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        instructionText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        instructionText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
//        instructionStackView.addArrangedSubview(instructionText)

        // central stackview
        let instructionStackView = UIStackView()
        instructionStackView.translatesAutoresizingMaskIntoConstraints = false
        instructionStackView.axis = .vertical
        instructionStackView.spacing = 8
        instructionStackView.distribution = .fillEqually
        view.addSubview(instructionStackView)
        instructionStackView.topAnchor.constraint(equalTo: instructionText.bottomAnchor, constant: 8).isActive = true
        instructionStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
        instructionStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        instructionStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        // next page
        let nextButton = CustomButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 16)
        nextButton.backgroundColor = UIColor(red:1.00, green:0.53, blue:0.26, alpha:1.0)
        nextButton.layer.cornerRadius = 10
        instructionStackView.addArrangedSubview(nextButton)
        
        // back page
        let backButton = CustomButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backPage), for: .touchUpInside)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 16)
        backButton.backgroundColor = UIColor(red: 2/255, green: 87/255, blue: 122/255, alpha: 1)
        backButton.layer.cornerRadius = 10
        instructionStackView.addArrangedSubview(backButton)
    }
    
    @objc private func nextScreen() {
        switch gaitTestType {
            case GaitTestType.TUG:
                GaitAlert.tugAlert(in: self, mode: AppMode.Clinical, delegate: self)
            case GaitTestType.SixMWT:
                GaitAlert.sixmwtAlert(in: self, mode: AppMode.Clinical, delegate: self)
            case GaitTestType.MCTSIB:
                GaitAlert.mctsibAlert(in: self, mode: AppMode.Clinical, delegate: self)
            default:
                print("error: could not find assesment")
        }
    }
    
    @objc private func backPage() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func onGaitTestComplete(resultsDict: Dictionary<String, Any>, resultsMessage: String, gaitTestType: GaitTestType, motionTracker: MotionTracker) {
        self.navigationController!.pushViewController(
            ClinicalCheckViewController(
                message: resultsMessage,
                resultsDict: resultsDict,
                motionTracker: motionTracker,
                gaitTestType: gaitTestType,
                subjectID: subjectID
            ),
            animated: true
        )
    }
}
