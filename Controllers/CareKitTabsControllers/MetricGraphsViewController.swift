//
//  MetricGraphsViewController.swift
//  Talaris
//
//  Created by Taha Baig on 1/21/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import Charts

// Graph of results from gait tests over time, currently only with dummy data
class MetricGraphsViewController: UIViewController {

    let metricsSegmentControl = UISegmentedControl(items: ["Speed", "Endurance", "Balance"])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // segment control from switching between results of three tests
        metricsSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        metricsSegmentControl.selectedSegmentIndex = 0
        view.addSubview(metricsSegmentControl)
        metricsSegmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        metricsSegmentControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        metricsSegmentControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        // graph creation
        let lc = LineChartView()
        lc.translatesAutoresizingMaskIntoConstraints = false
        var dataPoints = [ChartDataEntry]()
        for i in -10...10 {
            dataPoints.append(ChartDataEntry(x: Double(i), y: Double(i) * Double(i) * Double(i)))
        }
        
        let line1 = LineChartDataSet(values: dataPoints, label: "y = x^3")
        line1.colors = [.blue]
        
        let data = LineChartData(dataSet: line1)
        
        lc.data = data
        lc.chartDescription?.text = "Test Chart"

        view.addSubview(lc)
        lc.topAnchor.constraint(equalTo: metricsSegmentControl.bottomAnchor, constant: 10).isActive = true
        lc.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        lc.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        lc.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
    }
}
