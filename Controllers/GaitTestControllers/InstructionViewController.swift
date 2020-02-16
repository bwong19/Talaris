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
    
    private let messages = [
        GaitTestType.TUG: "The Timed-Up and Go test, also known as the TUG test, is a gait assessment used to measure speed. Before you begin the TUG test, please make sure you have placed a chair without wheels in an uncluttered area. Place a cone or marker 3 meters in front of the chair. Please wear your regular footwear and use a walking aid if needed. \nStarting in a seated position, stand up when you hear a tone. You then walk 3 meters, walk around the cone or marker, and walk back to the chair. The test ends automatically when you are seated in the chair again.",
        GaitTestType.SixMWT: "The 2-Minute Walk Test, also known as the 2MWT, is a gait assessment used to measure endurance. Before you begin the test, please make sure you have set up two cones between 12 meters and 30 meters apart. Please wear your regular footwear and use a walking aid, such as a cane or walker, if needed. After you have set up the two cones, please enter the distance between them. \nThe goal of this test is to walk as far as possible for 2 minutes. You will walk back and forth between the two cones. Try to walk in a tight circle around the cones when you make turns. Two minutes is a long time to walk, so you may get out of breath or tired. You can slow down or stop to rest as necessary, but please resume walking as soon as you can. The test ends automatically after 2 minutes.",
        GaitTestType.MCTSIB: "The Modified Clinical Test of Sensory Interaction in Balance, also known as mCTSIB, is a test used to measure balance. This test will be performed on the Biodex machine. There are 4 conditions, or sub-tests, for this test: \n (1) Eyes open on a hard surface \n (2) Eyes closed on a hard surface \n (3) Eyes open on a soft surface \n (4) Eyes closed on a soft surface \nThe goal of this test is to maintain your balance for 30 seconds for each condition. Stand as still as possible for 30 seconds with your arms by your sides. Each sub-test ends automatically after 30 seconds."
    ]
    
    init(gaitTestType: GaitTestType) {
        self.gaitTestType = gaitTestType
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
        instructionText.textAlignment = .left
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
                GaitAlert.tugAlert(in: self, mode: AppMode.CareKit, delegate: self)
            case GaitTestType.SixMWT:
                GaitAlert.sixmwtAlert(in: self, mode: AppMode.CareKit, delegate: self)
            case GaitTestType.MCTSIB:
                GaitAlert.mctsibAlert(in: self, mode: AppMode.CareKit, delegate: self)
            default:
                print("error: could not find assesment")
        }
    }
    
    @objc private func backPage() {
        self.navigationController!.popViewController(animated: true)
    }
    
    func onGaitTestComplete(resultsDict: Dictionary<String, Any>, resultsMessage: String, gaitTestType: GaitTestType, motionTracker: MotionTracker) {
        self.navigationController!.pushViewController(
            CheckViewController(
                message: resultsMessage,
                resultsDict: resultsDict,
                motionTracker: motionTracker,
                gaitTestType: gaitTestType
            ),
            animated: true
        )
    }
}
