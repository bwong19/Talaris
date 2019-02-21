//
//  TestViewController.swift
//  Talaris
//
//  Created by Debanik Purkayastha on 1/14/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit


class TestViewController: UIViewController {
    var tests = [String]()
    var current = 0
    let testImage = UIImageView()
    let testText = UILabel()
    let descriptionText = UILabel()
    
    public init() {
        var testList = [String]()
        testList.append("tug")
        testList.append("6mwt")
        testList.append("sway")
        self.tests = testList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "Onboarding"
        
        let imageName = tests[current] + ".png"
        testImage.image = UIImage(named: imageName)
        testImage.translatesAutoresizingMaskIntoConstraints = false
//        testImage.backgroundColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        view.addSubview(testImage)
        testImage.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        testImage.heightAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        testImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        testImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20).isActive = true
        
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.text = "This test measures speed."
        descriptionText.textColor = UIColor(red:0.00, green:146/255, blue:1, alpha:1.0)
        descriptionText.numberOfLines = 0
        descriptionText.textAlignment = .center
        descriptionText.font = UIFont.italicSystemFont(ofSize: 18)
        self.view.addSubview(descriptionText)
        descriptionText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        descriptionText.centerYAnchor.constraint(equalTo: testImage.topAnchor, constant: -60).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        descriptionText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        let leftButton = CustomButton()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.addTarget(self, action: #selector(goLeft), for: .touchUpInside)
        leftButton.setTitle("<-", for: .normal)
        leftButton.setTitleColor(.black, for: .normal)
        leftButton.titleLabel?.font = .systemFont(ofSize: 24)
        //leftButton.backgroundColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        self.view.addSubview(leftButton)
        leftButton.rightAnchor.constraint(equalTo: testImage.leftAnchor, constant: -20).isActive = true
        leftButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: view.frame.width/6).isActive = true
        
        let rightButton = CustomButton()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.addTarget(self, action: #selector(goRight), for: .touchUpInside)
        rightButton.setTitle("->", for: .normal)
        rightButton.setTitleColor(.black, for: .normal)
        rightButton.titleLabel?.font = .systemFont(ofSize: 24)
        //rightButton.backgroundColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        self.view.addSubview(rightButton)
        rightButton.leftAnchor.constraint(equalTo: testImage.rightAnchor, constant: 20).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: view.frame.width/6).isActive = true
        
        testText.translatesAutoresizingMaskIntoConstraints = false
        testText.text = "TUG Test"
        testText.textColor = UIColor(red:0.00, green:146/255, blue:1, alpha:1.0)
        testText.numberOfLines = 0
        testText.textAlignment = .center
        testText.font = UIFont.systemFont(ofSize: 30)
        self.view.addSubview(testText)
        testText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        testText.centerYAnchor.constraint(equalTo: testImage.bottomAnchor, constant: 50).isActive = true
        testText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        testText.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        let proceedButton = CustomButton()
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.addTarget(self, action: #selector(enterTest), for: .touchUpInside)
        proceedButton.setTitle("Proceed", for: .normal)
        proceedButton.titleLabel?.font = .systemFont(ofSize: 20)
        proceedButton.backgroundColor = UIColor(red:182/255, green:223/255, blue:1, alpha:1.0)
        proceedButton.layer.cornerRadius = 10
        self.view.addSubview(proceedButton)
        proceedButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        proceedButton.centerYAnchor.constraint(equalTo: testText.bottomAnchor, constant: 60).isActive = true
        proceedButton.heightAnchor.constraint(equalToConstant: view.frame.height / 12).isActive = true
        proceedButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
    }
    
    @objc func goLeft(_ sender : UIButton) {
        self.current = self.current - 1
        if (self.current < 0) {
            self.current = 2
        }
        
        let imageName = self.tests[self.current] + ".png"
        self.testImage.image = UIImage(named: imageName)
        if (self.tests[self.current] == "tug") {
            self.testText.text = "TUG Test"
            self.descriptionText.text = "This test measures speed."
        } else if (self.tests[self.current] == "6mwt") {
            self.testText.text = "Six Minute Walk Test";
            self.descriptionText.text = "This test measures endurance."
        } else if (self.tests[self.current] == "sway") {
            self.testText.text = "Sway Test"
            self.descriptionText.text = "This test measures balance."
        } else {
            print("Error")
        }
        
    }
    
    @objc func goRight(_ sender : UIButton) {
        self.current = self.current + 1
        if (self.current > 2) {
            self.current = 0
        }
        
        let imageName = tests[current] + ".png"
        testImage.image = UIImage(named: imageName)
        
        if (tests[current] == "tug") {
            testText.text = "TUG Test"
            descriptionText.text = "This test measures speed."
        } else if (tests[current] == "6mwt") {
            testText.text = "Six Minute Walk Test";
            descriptionText.text = "This test measures endurance."
        } else if (tests[current] == "sway") {
            testText.text = "Sway Test"
            descriptionText.text = "This test measures balance."
        } else {
            print("Error")
        }
    }
    
    @objc func enterTest(_ sender : UIButton) {
        if (tests[current] == "tug") {
            self.navigationController!.pushViewController(TUGViewController(), animated: true)
        } else if (tests[current] == "6mwt") {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Six Minute Walk Test", message: "Please provide the distance from your starting position to the turnaround point (in meters)", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                self.navigationController!.pushViewController(SIXMWTViewController(turnaroundDistance: Double(textField.text!)!), animated: true)
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        } else if (tests[current] == "sway") {
            self.navigationController!.pushViewController(SwayViewController(), animated: true)
        } else {
            print("Error")
        }
    }
    
//    func numberOfItems(in carousel: iCarousel) -> Int {
//        return 10
//    }
//
//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//        let testImage: UIImageView
//
//        if view != nil {
//            testImage = view as! UIImageView
//        } else {
//            testImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
//        }
//        testImage.image = UIImage(named: "test.jpg")
//
//        return testImage
//    }

        // Do any additional setup after loading the view.
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
