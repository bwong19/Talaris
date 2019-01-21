//
//  MetricGraphsViewController.swift
//  Talaris
//
//  Created by Taha Baig on 1/21/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit

class MetricGraphsViewController: UIViewController {

    let metricsSegmentControl = UISegmentedControl(items: ["Speed", "Endurance", "Balance"])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        metricsSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        metricsSegmentControl.selectedSegmentIndex = 0
        self.view.addSubview(metricsSegmentControl)
        metricsSegmentControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        metricsSegmentControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        metricsSegmentControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
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
