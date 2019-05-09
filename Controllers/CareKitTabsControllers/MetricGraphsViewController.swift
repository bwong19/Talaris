//
//  MetricGraphsViewController.swift
//  Talaris
//
//  Created by Taha Baig on 1/21/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import UIKit
import Charts

class MetricGraphsViewController: UIViewController {

    let metricsSegmentControl = UISegmentedControl(items: ["Speed", "Endurance", "Balance"])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        metricsSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        metricsSegmentControl.selectedSegmentIndex = 0
        self.view.addSubview(metricsSegmentControl)
        metricsSegmentControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        metricsSegmentControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        metricsSegmentControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
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

        self.view.addSubview(lc)
        lc.topAnchor.constraint(equalTo: metricsSegmentControl.bottomAnchor, constant: 10).isActive = true
        lc.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        lc.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        lc.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
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
