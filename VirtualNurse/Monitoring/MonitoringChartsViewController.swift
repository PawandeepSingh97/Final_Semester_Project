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
    
    var monitoringDataValue:[String] = ["0","0","0","0","0","0"]
    var cigValue:String="Today: 0 cigs";
    


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
    
    //Retrieve all dates
    var dates:[String] = ["0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       //Get current days in a week
       //Load all data as default
       setDefaultChartData()
        
       checkIfRecordExists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDefaultChartData()
        
        checkIfRecordExists()
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
        cell.monitoringTodayValue.text = monitoringDataValue[indexPath.row]
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
            cell.monitoringTodayValue.text = monitoringDataValue[indexPath.row]
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
            cell.monitoringTodayValue.text = monitoringDataValue[indexPath.row]
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
            cell.monitoringTodayValue.text = monitoringDataValue[indexPath.row]
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
            cell.monitoringTodayValue.text = monitoringDataValue[indexPath.row]
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
            cell.monitoringTodayValue.text = monitoringDataValue[indexPath.row]
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
        
            //Set it to all default Value
            self.bloodPressureData = [0,0,0,0,0,0,0,0]
            self.glucoseData = [0,0,0,0,0,0,0,0]
            self.heartRateData = [0,0,0,0,0,0,0,0]
            self.cigsData = [0,0,0,0,0,0,0,0]
            self.bmiData = [0,0,0,0,0,0,0,0]
            self.cholestrolData = [0,0,0,0,0,0,0,0]
        
            self.getAllDatesInCurrentWeek()
            let startDate = dates[0]
            let endDate = dates[6]
            xLabels.removeAll()

        MonitoringDataManager().getFilteredMonitoringRecordsBasedOnDate(startDate,endDate, "S9822477G") { (Monitoring) in
                
                //If segment week is clicked
                if(self.segmentedControl.selectedSegmentIndex == 0){
                        self.xLabels.removeAll()
                        let updatedxLabels = self.getAllDatesInCurrentWeek()
                        self.xLabels = updatedxLabels
                    
                        //Validation check whether the dates match
                        for i in self.allWeekDates {
                            if(i == Monitoring.dateCreated){
                                
                                //Store the date index in the array
                                let dateIndex = self.allWeekDates.index(of: i)!
                                //Replace the specifc item in the array
                                self.bloodPressureData[dateIndex] = CGFloat(Monitoring.systolicBloodPressure)
                                self.glucoseData[dateIndex] = CGFloat(Monitoring.glucose)
                                self.heartRateData[dateIndex] = CGFloat(Monitoring.heartRate)
                                if(Monitoring.cigsPerDay == -1){
                                    self.cigsData[dateIndex] = 0
                                }else{
                                    self.cigsData[dateIndex] = CGFloat(Monitoring.cigsPerDay)
                                }
                                self.bmiData[dateIndex] = CGFloat(Monitoring.bmi)
                                self.cholestrolData[dateIndex] = CGFloat(Monitoring.totalCholesterol)
                            }
                        }
                        self.chartsCollectionView.reloadData()

                }
                // If segment month is clicked
                if(self.segmentedControl.selectedSegmentIndex == 1){
                    //Set it to all default Value
                    self.bloodPressureData = [0,0,0,0,0,0,0,0,0,0,0,0]
                    self.glucoseData = [0,0,0,0,0,0,0,0,0,0,0,0]
                    self.heartRateData = [0,0,0,0,0,0,0,0,0,0,0,0]
                    self.cigsData = [0,0,0,0,0,0,0,0,0,0,0,0]
                    self.bmiData = [0,0,0,0,0,0,0,0,0,0,0,0]
                    self.cholestrolData = [0,0,0,0,0,0,0,0,0,0,0,0]
                    
                    self.xLabels.removeAll()
                    self.xLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                    self.chartsCollectionView.reloadData()
                }
                //If segement is click
                if(self.segmentedControl.selectedSegmentIndex == 2){
                    //Set it to all default Value
                    self.bloodPressureData = [0,0,0,0,0]
                    self.glucoseData = [0,0,0,0,0]
                    self.heartRateData = [0,0,0,0,0]
                    self.cigsData = [0,0,0,0,0]
                    self.bmiData = [0,0,0,0,0]
                    self.cholestrolData = [0,0,0,0,0]
                    
                    self.xLabels.removeAll()
                    self.xLabels = ["2016","2017","2018","2018","2016","2017","2018","2018","2016","2017","2018","2018"]
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
        dates.removeAll()

        //Loop thru all 7 days in a week
        for i in 0...12{
            
            //Adding one day each till it reaches the 7th day
            let daysOfAWeek = calendar.date(byAdding: .day, value: i, to: mondaysDate)
            //print("Adding 7 days \(String(describing: daysOfAWeek))")
        
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
            
            //Store all dates for database check
            dates.append("\(day)/\(updatedMonth)/\(year)")
        }
        
        return xLabels
    }
    
    
    func setDefaultChartData(){
        
        self.getAllDatesInCurrentWeek()
        let startDate = dates[0]
        let endDate = dates[6]
        xLabels.removeAll()
        
        //Set it to all default Value
        self.bloodPressureData = [0,0,0,0,0,0,0,0]
        self.glucoseData = [0,0,0,0,0,0,0,0]
        self.heartRateData = [0,0,0,0,0,0,0,0]
        self.cigsData = [0,0,0,0,0,0,0,0]
        self.bmiData = [0,0,0,0,0,0,0,0]
        self.cholestrolData = [0,0,0,0,0,0,0,0]
        
        MonitoringDataManager().getFilteredMonitoringRecordsBasedOnDate(startDate,endDate, "S9822477G") { (Monitoring) in
            
                self.xLabels.removeAll()
                //self.data.removeAll()
                //self.data2.removeAll()
                //self.data3.removeAll()
                let updatedxLabels = self.getAllDatesInCurrentWeek()
                self.xLabels = updatedxLabels
            
                //Validation check whether the dates match
                for i in self.allWeekDates {
                    if(i == Monitoring.dateCreated){
                        //Store the date index in the array
                        let dateIndex = self.allWeekDates.index(of: i)!
                        //Replace the specifc item in the array
                        self.bloodPressureData[dateIndex] = CGFloat(Monitoring.systolicBloodPressure)
                        self.glucoseData[dateIndex] = CGFloat(Monitoring.glucose)
                        self.heartRateData[dateIndex] = CGFloat(Monitoring.heartRate)
                        if(Monitoring.cigsPerDay == -1){
                          self.cigsData[dateIndex] = 0
                        }else{
                          self.cigsData[dateIndex] = CGFloat(Monitoring.cigsPerDay)
                        }
                        self.bmiData[dateIndex] = CGFloat(Monitoring.bmi)
                        print("Taufik\(self.bmiData)")
                        self.cholestrolData[dateIndex] = CGFloat(Monitoring.totalCholesterol)
                    }
                }
                self.chartsCollectionView.reloadData()
    
        }
    }
    
    //Check if monitoring record exists if not create one
    func checkIfRecordExists(){
        
        //Retrieve from controller to checkIfRecordExists
        MonitoringController().checkIfRecordExists { (monitoring) in
            
            //Retrieve bloopPressure, Glucose, Heartrate, cigarette, bmi, cholesterol value
            let bloodPressureValue = "Today: \(monitoring.systolicBloodPressure)"
            let glucoseValue = "Today: \(monitoring.glucose) mgdL"
            let heartRateValue = "Today: \(monitoring.heartRate) bpm"
            if (monitoring.cigsPerDay != -1){
                self.cigValue = "Today: \(monitoring.cigsPerDay) cigs"
            }
            let bmiValue = "Today: \(monitoring.bmi)"
            let cholesterolValue = "Today: \(monitoring.totalCholesterol) mgdL"
            
            //Clear all the array first before appending
            self.monitoringDataValue.removeAll()
            
            //Appending all the values to monitoringValue array
            self.monitoringDataValue.append(bloodPressureValue)
            self.monitoringDataValue.append(glucoseValue)
            self.monitoringDataValue.append(heartRateValue)
            self.monitoringDataValue.append(self.cigValue)
            self.monitoringDataValue.append(bmiValue)
            self.monitoringDataValue.append(cholesterolValue)
            
            //Reload the collection view
            self.chartsCollectionView.reloadData()
            
        }
        
        
    } //end of function
    
   

}
