//
//  ViewTodayResultsViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 6/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class ViewTodayResultsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellScaling: CGFloat = 0.6
    
    
    var patient:Patient?
    
    var monitoringData:[String] = ["Blood Pressure","Glucose","Heart Rate","Cigarette","BMI","Cholesterol"]
    var cellBackgroundColour = [0xF44336,0x3F51B5,0xE91E63,0xFF9800,0x009688,0x9C27B0]
    var monitoringDataValue:[String] = ["0","0","0","0","0","0"]
    var healthStatus:[String] = ["","","","","",""]
    var healthAdvice:[String] = ["","","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the delegates of collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        //Padding of the width and height of collectionview
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
       let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
       layout.itemSize = CGSize(width:cellWidth, height: cellHeight)
       collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
       //Load all monitoring records
       loadAllMonitoringRecords()
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    @IBAction func closeButtonClicked(_ sender: Any) {
        
       //return to monitoring dashboard
       navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monitoringData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Reuse the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewTodayCell", for: indexPath) as! ViewTodayResultsCollectionViewCell
        
        //Designing guidlines for cell
        let cornerRadius : CGFloat = 10.0
        //Set backgroundColor for each cell
        cell.backgroundColor = UIColor(hex: self.cellBackgroundColour[indexPath.row])
        //Set cornerRadius for each cell
        cell.layer.cornerRadius = cornerRadius
        //Set text for each cell
        cell.monitoringNames.text = self.monitoringData[indexPath.row]
        //Set monitoring value for each text
        cell.monitoringValue.text = self.monitoringDataValue[indexPath.row]
        //Set the health status
        cell.monitoringStatus.text = self.healthStatus[indexPath.row]
        //Set the health advice
        cell.healthAdvice.text = self.healthAdvice[indexPath.row]
    
    
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthInludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthInludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthInludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    //Check if monitoring record exists if not create one
    func loadAllMonitoringRecords(){
        
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = "S9822477G"
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patient!) { (monitoring) in
            //Retrieved results from Database
            let retrievedPatientNric = monitoring.nric
            let retrievedDateCreated = monitoring.dateCreated
            
            //If record exists in database
            if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
                print("record exists")
                
                //Retrieve bloopPressure, Glucose, Heartrate, cigarette, bmi, cholesterol value
                let bloodPressureValue = "\(monitoring.systolicBloodPressure)/\(monitoring.diastolicBloodPressure) mmHg"
                let glucoseValue = "\(monitoring.glucose) mgdL"
                let heartRateValue = "\(monitoring.heartRate) bpm"
                let cigValue = "\(monitoring.cigsPerDay) cigs"
                let bmiValue = "\(monitoring.bmi)"
                let cholesterolValue = "\(monitoring.totalCholesterol) mgdL"
                
                //Clear all the array first before appending
                self.monitoringDataValue.removeAll()
                
                //Appending all the values to monitoringValue array
                self.monitoringDataValue.append(bloodPressureValue)
                self.monitoringDataValue.append(glucoseValue)
                self.monitoringDataValue.append(heartRateValue)
                self.monitoringDataValue.append(cigValue)
                self.monitoringDataValue.append(bmiValue)
                self.monitoringDataValue.append(cholesterolValue)
                
                //Pass all monitoring value as parameters to check whether healthy
                self.checkIfHealthy(systolicBloodPressure: monitoring.systolicBloodPressure, diastolicBloodPressure: monitoring.diastolicBloodPressure, glucose: monitoring.glucose, heartrate: monitoring.heartRate, cigs: monitoring.cigsPerDay, bmi: monitoring.bmi, cholesterol: monitoring.totalCholesterol)
      
                //Reload the collection view
                self.collectionView.reloadData()
                
            }
        }
    }
    
    //Check if the monitoring value is healthy
    func checkIfHealthy(systolicBloodPressure:Double, diastolicBloodPressure:Double, glucose:Int, heartrate:Double, cigs:Int, bmi:Double, cholesterol:Int ){
        
        //Empty the array
        self.healthStatus.removeAll()
        self.healthAdvice.removeAll()
        
        //Check if systolicBp and distolicBp is in healthy range
        if(systolicBloodPressure != 0 || diastolicBloodPressure != 0){
            
            if (systolicBloodPressure <= 120 && diastolicBloodPressure <= 80){
                self.healthStatus.append("Healthy")
                self.healthAdvice.append("Good Job! You have systolicBp and distolicBp are in range.")
            }
            else if(systolicBloodPressure >= 140 && systolicBloodPressure <= 90){
                self.healthStatus.append("Unhealthy")
                self.healthAdvice.append("Keep a food diary to monitor what you eat, try reducing sodium in your diet.")
            }
            else{
                self.healthStatus.append("Moderate")
                self.healthAdvice.append("Keep a food diary to monitor what you eat, try reducing sodium in your diet.")
            }

        }
        else{
               self.healthStatus.append("")
               self.healthAdvice.append("")
        }
        
        //Check if glucose is in healthy range
        if (glucose != 0){
            
            if (glucose >= 70 && glucose <= 100){
                self.healthStatus.append("Normal")
                self.healthAdvice.append("Good Job! You have a healthy glucose level.Keep up the good work.")
            }
            else {
                self.healthStatus.append("Danger")
                self.healthAdvice.append("Control your carb intake in your food diet. Always drink water and stay hydrated.")
            }
        }
        else{
            self.healthStatus.append("")
            self.healthAdvice.append("")
        }
        
        //Check if heart rate is in healthy range
        if (heartrate != 0){
            
            if (heartrate >= 60.0 && heartrate <= 100.0){
                self.healthStatus.append("Healthy")
                self.healthAdvice.append("Well done! You are having a healthy heart rate.")
            }
            else{
                self.healthStatus.append("Unhealthy")
                self.healthAdvice.append("Reduce stress. Performing meditation, tai chi lowers the heart rate over time.")
            }
        }
        else{
            self.healthStatus.append("")
            self.healthAdvice.append("")
        }
       
        //Check if cigs is decreasing
        if (cigs != -1){
            
            if (cigs == 0){
                self.healthStatus.append("Good")
                self.healthAdvice.append("Great job that you did not smoke today. Try to maintain this everyday.")
            }else{
                self.healthStatus.append("Can improve")
                self.healthAdvice.append("Try to reduce the amount of cigrattes per day")
            }
        }
        else{
            self.healthStatus.append("")
            self.healthAdvice.append("")
        }
        
         //Check if bmi is in healthy range
        if (bmi != 0){
            if (bmi < 18.5){
                self.healthStatus.append("Underweight")
                self.healthAdvice.append("Eat at least five portions of a variety of fruit and vegetables every day.")
            }
            else if(bmi >= 18.5 && bmi <= 24.9){
                self.healthStatus.append("Healthy")
                self.healthAdvice.append("Continue the work you are doing to keep yourself healthy.")
            }
            else if(bmi >= 25 && bmi <= 29.9){
                self.healthStatus.append("Overweight")
                self.healthAdvice.append("Try losing excess weight by going walking everyday for 30 mins")
            }
            else if(bmi >= 30){
                self.healthStatus.append("Obese")
                self.healthAdvice.append("Reduced-calorie diet and take up activities such as walking, jogging")
            }
        }
        else{
            self.healthStatus.append("")
            self.healthAdvice.append("")
        }
        
        
        if (cholesterol != 0){
            //Check if cholesterolValue is in healthy range
            if (cholesterol <= 200){
                self.healthStatus.append("Desirable")
                self.healthAdvice.append("You have a desirable cholesterol level. Maintain the good work.")
            }
            else {
                self.healthStatus.append("High")
                self.healthAdvice.append("Eat foods rich in omega-3 fatty acids, food with high soluble fiber.")
            }
        }
        else{
            self.healthStatus.append("")
            self.healthAdvice.append("")
        }
        
        
        
    }

}
