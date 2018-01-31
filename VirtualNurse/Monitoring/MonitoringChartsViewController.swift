//
//  MonitoringChartsViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 30/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class MonitoringChartsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,LineChartDelegate {
   
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var chartsCollectionView: UICollectionView!
    var label = UILabel()
 
    var cellBackgroundColour: [Int] = [0xF44336,0x3F51B5,0xE91E63,0xFF9800,0x009688,0x9C27B0
    ,0x2196F3,0x2196F3,0x2196F3,0x2196F3,0x2196F3]
    
    var monitoringData:[String]=["Blood Pressure","Glucose","Heart Rate","Cigarette","BMI","Cholesterol","Medicine Search","Top up","Reminder","Scan Medicine","Appointment"]
    
//    var data: [CGFloat] = [10, 4, -2, 11, 13, 15,3, 4, -2, 11, 13, 15]
//    var data2: [CGFloat] = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2]
//    var data3: [CGFloat] = [100, 90, 53, 92, 172, 202]
    
    var bloodPressureData: [CGFloat] = [0]
    var glucoseData: [CGFloat] = [0]
    var heartRateData: [CGFloat] = [0]
    var cigsData: [CGFloat] = [0]
    var bmiData: [CGFloat] = [0]
    var cholestrolData: [CGFloat] = [0]
    
    // simple line with custom x axis labels
//    var xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var xLabels:[String] = ["0"]
    
    var allWeekDates:[String] = ["0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       //Get current days in a week
       let updatedxLabels = self.getAllDatesInCurrentWeek()
       xLabels = updatedxLabels
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Reuse the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonitoringChartsCollectionViewCell", for: indexPath) as! MonitoringChartsCollectionViewCell
        
        //Set background color of cell
        cell.backgroundColor = UIColor(hex: self.cellBackgroundColour[indexPath.row])
        
        //Set the radius of the cell
        cell.layer.cornerRadius = 10.0
        
        var views: [String: AnyObject] = [:]
        
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        //self.view.addSubview(label)
        views["label"] = label
        //            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        //            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: [], metrics: nil, views: views))
        
        
        //Blood Pressure
        if(indexPath.row == 0){
        cell.monitoringName.text = monitoringData[indexPath.row]
        cell.line.clearAll()
        cell.line.animation.enabled = true
        cell.line.area = true
        cell.line.x.labels.visible = true
        cell.line.x.grid.count = 10
        cell.line.y.grid.count = 5
        cell.line.x.labels.values = xLabels
        cell.line.y.labels.visible = true
        cell.line.addLine(bloodPressureData)
        cell.line.colors = [UIColor.white]
        
        cell.line.translatesAutoresizingMaskIntoConstraints = false
        cell.line.delegate = self
        cell.line.backgroundColor = UIColor.clear
        //self.view.addSubview(line)
        views["chart"] = cell.line
        }
        
        //Glucose
        if(indexPath.row == 1){
            cell.monitoringName.text = monitoringData[indexPath.row]
            cell.line.clearAll()
            cell.line.animation.enabled = true
            cell.line.area = true
            cell.line.x.labels.visible = true
            cell.line.x.grid.count = 10
            cell.line.y.grid.count = 5
            cell.line.x.labels.values = xLabels
            cell.line.y.labels.visible = true
            cell.line.addLine(glucoseData)
            cell.line.colors = [UIColor.white]
            
            cell.line.translatesAutoresizingMaskIntoConstraints = false
            cell.line.delegate = self
            cell.line.backgroundColor = UIColor.clear
            //self.view.addSubview(line)
            views["chart"] = cell.line
        }
        //Heart Rate
        if(indexPath.row == 2){
            cell.monitoringName.text = monitoringData[indexPath.row]
            cell.line.clearAll()
            cell.line.animation.enabled = true
            cell.line.area = true
            cell.line.x.labels.visible = true
            cell.line.x.grid.count = 10
            cell.line.y.grid.count = 5
            cell.line.x.labels.values = xLabels
            cell.line.y.labels.visible = true
            cell.line.addLine(heartRateData)
            cell.line.colors = [UIColor.white]
            
            cell.line.translatesAutoresizingMaskIntoConstraints = false
            cell.line.delegate = self
            cell.line.backgroundColor = UIColor.clear
            //self.view.addSubview(line)
            views["chart"] = cell.line
        }
        //Cigs
        if(indexPath.row == 3){
            cell.monitoringName.text = monitoringData[indexPath.row]
            cell.line.clearAll()
            cell.line.animation.enabled = true
            cell.line.area = true
            cell.line.x.labels.visible = true
            cell.line.x.grid.count = 10
            cell.line.y.grid.count = 5
            cell.line.x.labels.values = xLabels
            cell.line.y.labels.visible = true
            cell.line.addLine(cigsData)
            cell.line.colors = [UIColor.white]
            
            cell.line.translatesAutoresizingMaskIntoConstraints = false
            cell.line.delegate = self
            cell.line.backgroundColor = UIColor.clear
            //self.view.addSubview(line)
            views["chart"] = cell.line
        }
        
        //BMI
        if(indexPath.row == 4){
            cell.monitoringName.text = monitoringData[indexPath.row]
            cell.line.clearAll()
            cell.line.animation.enabled = true
            cell.line.area = true
            cell.line.x.labels.visible = true
            cell.line.x.grid.count = 10
            cell.line.y.grid.count = 5
            cell.line.x.labels.values = xLabels
            cell.line.y.labels.visible = true
            cell.line.addLine(bmiData)
            cell.line.colors = [UIColor.white]
            
            cell.line.translatesAutoresizingMaskIntoConstraints = false
            cell.line.delegate = self
            cell.line.backgroundColor = UIColor.clear
            //self.view.addSubview(line)
            views["chart"] = cell.line
        }
        
        //Cholestrol
        if(indexPath.row == 5){
            cell.monitoringName.text = monitoringData[indexPath.row]
            cell.line.clearAll()
            cell.line.animation.enabled = true
            cell.line.area = true
            cell.line.x.labels.visible = true
            cell.line.x.grid.count = 10
            cell.line.y.grid.count = 5
            cell.line.x.labels.values = xLabels
            cell.line.y.labels.visible = true
            cell.line.addLine(cholestrolData)
            cell.line.colors = [UIColor.white]
            
            cell.line.translatesAutoresizingMaskIntoConstraints = false
            cell.line.delegate = self
            cell.line.backgroundColor = UIColor.clear
            //self.view.addSubview(line)
            views["chart"] = cell.line
        }
        
        return cell
    }
    
   
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
//        if let chart = line {
//            chart.setNeedsDisplay()
//        }
    }
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
//        label.text = "x: \(x)     y: \(yValues)"
    }
    
    @IBAction func segementedControlClicked(_ sender: Any) {
        
            self.bloodPressureData.removeAll()
            self.glucoseData.removeAll()
            self.heartRateData.removeAll()
            self.cigsData.removeAll()
            self.bmiData.removeAll()
            self.cholestrolData.removeAll()
        
            MonitoringDataManager().getFilteredMonitoringRecordsBasedOnDate("", "", "S9822477G") { (Monitoring) in
                
                 //Append all the results to the array
                 self.bloodPressureData.append(CGFloat(Monitoring.systolicBloodPressure))
                 self.glucoseData.append(CGFloat(Monitoring.glucose))
                 self.heartRateData.append(CGFloat(Monitoring.heartRate))
                 self.cigsData.append(CGFloat(Monitoring.cigsPerDay))
                 self.bmiData.append(CGFloat(Monitoring.bmi))
                 self.cholestrolData.append(CGFloat(Monitoring.totalCholesterol))
                
                
                //If segment week is clicked
                if(self.segmentedControl.selectedSegmentIndex == 0){
                        self.xLabels.removeAll()
                        //self.data.removeAll()
                        //self.data2.removeAll()
                        //self.data3.removeAll()
                        let updatedxLabels = self.getAllDatesInCurrentWeek()
                        self.xLabels = updatedxLabels
                    
                        //Validation check whether the dates match
                        for i in self.allWeekDates {
                            if(i == Monitoring.dateCreated){
                                print(i)
                                print(Monitoring.dateCreated)
                                print("HI\(String(describing: self.allWeekDates.index(of: i)))")
                            }
                        }
                        //self.data = [3, 4, -2, 11, 13, 15,3, 4, -2, 11, 13, 15]
                        //self.data2 = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2]
                        //self.data3 = [100, 90, 53, 92, 172, 202]
                        self.chartsCollectionView.reloadData()

                }
                // If segment month is clicked
                if(self.segmentedControl.selectedSegmentIndex == 1){
                    self.xLabels.removeAll()
//                    self.data.removeAll()
//                    self.data2.removeAll()
//                    self.data3.removeAll()
                    self.xLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                    //self.data = [0, 4, -2, 11, 13, 15,3, 4, -2, 11, 13, 15]
                    //self.data2 = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2]
                    //self.data3 = [100, 90, 53, 92, 172, 202]
                    self.chartsCollectionView.reloadData()
                }
                //If segement is click
                if(self.segmentedControl.selectedSegmentIndex == 2){
                    self.xLabels.removeAll()
//                    self.data.removeAll()
//                    self.data2.removeAll()
//                    self.data3.removeAll()
                    self.xLabels = ["2016","2017","2018","2018","2016","2017","2018","2018","2016","2017","2018","2018"]
                    //self.data = [10, 4, -2, 11, 13, 15,3, 4, -2, 11, 13, 15]
                    //self.data2 = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2]
                    //self.data3 = [100, 90, 53, 92, 172, 202]
                    self.chartsCollectionView.reloadData()
                }
            }
        
    }
    
    
    //Getting all the Currentdate in a week
    func getAllDatesInCurrentWeek()->Array<String>{
        
        //Get the monday of the week
        var mondaysDate: Date {
            return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        }
        
        //print(mondaysDate.description(with: .current))
        
        
        let calendar = Calendar.current
        
        allWeekDates.removeAll()

        //Loop thru all 7 days in a week
        for i in 0...12{
            
            //Adding one day each till it reaches the 7th day
            let daysOfAWeek = calendar.date(byAdding: .day, value: i, to: mondaysDate)
//            print("Adding 7 days \(String(describing: daysOfAWeek))")
        
            //Get the year,month,day
            let year = calendar.component(.year, from: daysOfAWeek!)
            let month = calendar.component(.month, from: daysOfAWeek!)
            let day = calendar.component(.day, from: daysOfAWeek!)
            //print("This is mondays date \(day)/\(month)")
            //print("This is monday's year \(year)")
            let dayMonth = "\(day)/\(month)"
            xLabels.append(dayMonth)
            
            //Updating the month with leading zeroes
            let updatedDay = String(format: "%02d", day)
            let updatedMonth = String(format: "%02d", month)
            let dayMonthYear = "\(updatedDay)/\(updatedMonth)/\(year)"
            allWeekDates.append(String(describing: dayMonthYear))
            

          
        }
        
        return xLabels
        
      
    }
    
   

}
