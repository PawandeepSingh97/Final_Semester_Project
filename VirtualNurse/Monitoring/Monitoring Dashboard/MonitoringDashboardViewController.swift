//
//  MonitoringDashboardViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 10/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import Alamofire
import CoreML

class MonitoringDashboardViewController:UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var chdPredictionLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chdStatus: UIView!
    
    let cellScaling: CGFloat = 0.6
 
    //Declating Variables
    var monitoringData:[String] = ["Blood Pressure","Glucose","Heart Rate","Cigarette","BMI","Cholesterol"]
    var cellBackgroundColour = [0xF44336,0x3F51B5,0xE91E63,0xFF9800,0x009688,0x9C27B0]
    var monitoringDataValue:[String] = ["0","0","0","0","0","0"]
    var healthStatus:[String] = ["","","","","",""]
    var healthAdvice:[String] = ["","","","","",""]
    var chdValue:Bool = false
    var cigValue:String="0 cigs";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the delegates of collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //Call the chdDesign UIView funciton
        DesignChdView()
        
        //Call the collectionViewSizing function
        collectionViewSizing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set navigation bar colour
        //self.setNavigationBarItem()
        
        //Load all monitoring records
        loadAllMonitoringRecords()
    }
    
    //Number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monitoringData.count
    }
    
    //Returns cell Item Eg: Text, Design
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Reuse the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewTodayCell", for: indexPath) as! MonitoringDashboardCollectionViewCell
        
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
    
    //Scrolling of content
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthInludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthInludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthInludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    //Returns the selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected row is" ,indexPath.row)
        
        //Instatiate Monitoring Storyboard
        let storyboard = UIStoryboard(name:"MonitoringStoryboard" , bundle:nil)
        
        //When button clicked navigate to different pages
        if(indexPath.row == 0){
            //Navigation Programmitically
            let BloodPressureViewController = storyboard.instantiateViewController(withIdentifier: "BloodPressureViewController") as! BloodPressureViewController
            self.navigationController?.pushViewController(BloodPressureViewController, animated: true)
        }
        if(indexPath.row == 1){
            //Navigation Programmitically
            let GlucoseViewController = storyboard.instantiateViewController(withIdentifier: "GlucoseViewController") as! GlucoseViewController
            self.navigationController?.pushViewController(GlucoseViewController, animated: true)
        }
        if(indexPath.row == 2){
            //Navigation Programmitically
            let HeartRateViewController = storyboard.instantiateViewController(withIdentifier: "HeartRateViewController") as! HeartRateViewController
            self.navigationController?.pushViewController(HeartRateViewController, animated: true)
        }
        if(indexPath.row == 3){
            //Navigation Programmitically
            let CigaretteViewController = storyboard.instantiateViewController(withIdentifier: "CigaretteViewController") as! CigaretteViewController
            self.navigationController?.pushViewController(CigaretteViewController, animated: true)
        }
        if(indexPath.row == 4){
            //Navigation Programmitically
            let BMIViewController = storyboard.instantiateViewController(withIdentifier: "BMIViewController") as! BMIViewController
            self.navigationController?.pushViewController(BMIViewController, animated: true)
        }
        if(indexPath.row == 5){
            //Navigation Programmitically
            let CholesterolViewController = storyboard.instantiateViewController(withIdentifier: "CholesterolViewController") as! CholesterolViewController
            self.navigationController?.pushViewController(CholesterolViewController, animated: true)
        }
    }
    
    //Designing the CHD UIView
    func DesignChdView(){
        let cornerRadius : CGFloat = 10.0
        chdStatus.backgroundColor = UIColor(hex:0x212121)
        chdStatus.layer.cornerRadius = cornerRadius
    }
    
    //Predict CHD
    func predictCHD(id:String, nric:String, gender:String, age:Int, education:String, currentSmoker:Bool, cigsPerDay:Int, bpMedicine:Bool, prevalentStroke:Bool, prevalentHypertension:Bool, diabetes:Bool, totalCholesterol:Int, systolicBloodPressure:Double, diastolicBloodPressure:Double, bmi:Double, heartRate:Double, glucose:Int) {
        //Instatiate the ml model
        let model = framingham()
        
        //Instatiating a multiarray
        let mlinput = try? MLMultiArray (shape: [NSNumber(value: 15)], dataType: MLMultiArrayDataType.double)
        
        var genderValue:Int;
        
        //Check if gender is male or female
        if(gender == "male"){
            genderValue = 1
        }else{
            genderValue = 0
        }
        
        //Passing all var as input to the ML
        mlinput![0] = NSNumber(value: genderValue)
        mlinput![1] = NSNumber(value: age)
        mlinput![2] = NSNumber(value: Int(education)!)
        mlinput![3] = NSNumber(value: currentSmoker)
        mlinput![4] = NSNumber(value: cigsPerDay)
        mlinput![5] = NSNumber(value: bpMedicine)
        mlinput![6] = NSNumber(value: prevalentStroke)
        mlinput![7] = NSNumber(value: prevalentHypertension)
        mlinput![8] = NSNumber(value: diabetes)
        mlinput![9] = NSNumber(value: totalCholesterol)
        mlinput![10] = NSNumber(value: systolicBloodPressure)
        mlinput![11] = NSNumber(value: diastolicBloodPressure)
        mlinput![12] = NSNumber(value: bmi)
        mlinput![13] = NSNumber(value: heartRate)
        mlinput![14] = NSNumber(value: glucose)
        
        //Passing in the input and predicting the output
        guard let CHD = try? model.prediction(input1: mlinput!) else {
            fatalError("Unexpected Runtime Array")
        }
        
        //Retrieving the output
        let output = CHD.output1
        var finalOutput = round(Double(output[0]))
        
        if (finalOutput == 1.0){
            
            //Set label to RISK OF HEART DISEASE! if detected CHD
            self.chdPredictionLabel.text = "RISK OF HEART DISEASE!"
            //Get the CHD value
            chdValue = true
            
            //Animate the UI view when there is a risk
            UIView.animate(withDuration: 1, animations: {
                self.chdStatus.backgroundColor = UIColor(hex:0xD50000)
                self.chdStatus.frame.size.width += 10
                self.chdStatus.frame.size.height += 10
            }) { _ in
                UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
                    self.chdStatus.frame.origin.y -= 20
                })
            }
            
        }
        else{
            
            //Set label to NO RISK OF HEART DISEASE if not detected CHD
            self.chdPredictionLabel.text = "NO RISK OF HEART DISEASE"
            
            //Get the CHD value
            chdValue = false
        }
        
        //Retrive patient nric and today's date
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = helperClass().getPatientNric()
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve specific id in the monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patientNric) { (monitoring) in
            
            //Retrieved results from Database
            let retrievedPatientNric = monitoring.nric
            let retrievedDateCreated = monitoring.dateCreated
            
            //If record exists in database
            if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
                print("record exists")
                
                //Get the azure table unique id
                let azureTableId = monitoring.id
                
                
                //Declare updated parameters
                let updatedParameters: Parameters = [
                    "tenYearCHD": self.chdValue
                ]
                
                //Update the tenYearCHD in the monitoring record
                MonitoringDataManager().patchMonitoringRecord(azureTableId,updatedParameters, success: { (success) in
                    print(success)
                }) { (error) in
                    print(error)
                }
                
            }
        }
        
        
    }
    
    //Check if monitoring record exists if not create one
    func loadAllMonitoringRecords(){
        
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = helperClass().getPatientNric()
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patientNric) { (monitoring) in
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
                if (monitoring.cigsPerDay != -1){
                     self.cigValue = "\(monitoring.cigsPerDay) cigs"
                }
                let bmiValue = "\(monitoring.bmi)"
                let cholesterolValue = "\(monitoring.totalCholesterol) mgdL"
                
                //Clear all the array first before appending
                self.monitoringDataValue.removeAll()
                
                //Appending all the values to monitoringValue array
                self.monitoringDataValue.append(bloodPressureValue)
                self.monitoringDataValue.append(glucoseValue)
                self.monitoringDataValue.append(heartRateValue)
                self.monitoringDataValue.append(self.cigValue)
                self.monitoringDataValue.append(bmiValue)
                self.monitoringDataValue.append(cholesterolValue)
                
                //Pass all monitoring value as parameters to check whether healthy
                self.checkIfHealthy(systolicBloodPressure: monitoring.systolicBloodPressure, diastolicBloodPressure: monitoring.diastolicBloodPressure, glucose: monitoring.glucose, heartrate: monitoring.heartRate, cigs: monitoring.cigsPerDay, bmi: monitoring.bmi, cholesterol: monitoring.totalCholesterol)
                
                //If values are entered then predictCHD
                if (monitoring.heartRate != 0 && monitoring.diastolicBloodPressure != 0 && monitoring.systolicBloodPressure != 0 && monitoring.glucose != 0 && monitoring.cigsPerDay != -1 && monitoring.bmi != 0 && monitoring.totalCholesterol != 0){
                    //Predict CHD
                    self.predictCHD(id: monitoring.id, nric: monitoring.nric, gender: monitoring.gender, age: monitoring.age, education: monitoring.education, currentSmoker: monitoring.currentSmoker, cigsPerDay: monitoring.cigsPerDay, bpMedicine: monitoring.bpMedicine, prevalentStroke: monitoring.prevalentStroke, prevalentHypertension: monitoring.prevalentHypertension, diabetes: monitoring.diabetes, totalCholesterol: monitoring.totalCholesterol, systolicBloodPressure: monitoring.systolicBloodPressure, diastolicBloodPressure: monitoring.diastolicBloodPressure, bmi: monitoring.bmi, heartRate: monitoring.heartRate, glucose: monitoring.glucose)
                }
                else{
                    self.chdPredictionLabel.text = "NO RISK OF HEART DISEASE"
                }
                
                //Reload the collection view
                self.collectionView.reloadData()
                
            }
        }
    }
    
    //Handle the sizing of the collection view
    func collectionViewSizing(){
        //Collection View Sizing
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        //Padding of the width and height of collectionview
        let insetX = (view.bounds.width - cellWidth) / 9.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width:cellWidth, height: cellHeight)
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
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

    
