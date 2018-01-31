//
//  MonitoringViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 29/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import CoreML
import Alamofire


class HomeDashboardViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //PATIENT DATA
    // DATA PASSED FROM LOGIN
    //IMRAN, CHANGE UR CODES USING THE VARIABLE
    var patient:Patient?;
    
    //    @IBOutlet weak var viewTodayResultsButton: UIButton!
    @IBOutlet weak var chdPredictionLabel: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var overallStatus: UIView!
    
    //Declaration of variables
    //    var monitoringData:[[String]] = [["Blood Pressure","Glucose","Heart Rate","Cigarette","BMI","Cholesterol"] ,["Medicine Search","Top up","Reminder","Scan Medicine"]]
    var monitoringData:[String]=["Blood Pressure","Glucose","Heart Rate","Cigarette","BMI","Cholesterol","Medicine Search","Reminder"]
    var monitoringImages: [String] = ["redBloodPressure","blueGlucose","pinkheart","orangeCig","greenWeight","ruler","redBloodPressure","blueGlucose","pinkheart","orangeCig","orangeCig"]
    var circleLogo: [String] = ["redOval","blueOval","pinkoval","orangeOval","greenOval","purpleOval"]
    var monitoredTicks: [String] = ["redTick","blueTick","pinkTick","orangeTick","greenTick","purpleTick"]
    //var cellBackgroundColour = [0xF44336,0x3F51B5,0xE91E63,0xFF9800,0x009688,0x9C27B0,0xF44336,0x3F51B5,0xE91E63,0xFF9800]
    //    var cellBackgroundColour: [[Int]] = [[0xF44336,0x3F51B5,0xE91E63,0xFF9800,0x009688,0x9C27B0],
    //    [0x2196F3,0x2196F3,0x2196F3,0x2196F3]]
    
    //Real
//    var cellBackgroundColour: [Int] = [0xF44336,0x3F51B5,0xE91E63,0xFF9800,0x009688,0x9C27B0
//        ,0x2196F3,0x2196F3,0x2196F3,0x2196F3,0x2196F3]
    var cellBackgroundColour: [Int] = [0x3F51B5,0x3F51B5,0x3F51B5,0x3F51B5,0x3F51B5,0x3F51B5
        ,0x3F51B5,0x9C27B0]
    
    var monitoringValue:[String] = ["140/80 mmHg","120 mgdL","110 bpm","10 cigs","28","80 mgdL","10","10"]
    
    
    
    
    var checkIfMonitored:[String] = []
    var chdValue:Bool = false
    
    struct Storyboard {
        static let sectionHeaderView = "SectionHeaderView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the delegates of collectionView
        self.CollectionView.delegate = self
        self.CollectionView.dataSource = self
        
        
        //Call the DesignView function
        DesignView()
        
        //       //Call the design function for viewTodayResultsButton
        //       DesignViewResultsTodayButton()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Set navigation bar colour
        //self.setNavigationBarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //reload the collectionView
        checkIfRecordExists()
        
        
        
    }
    
    //Number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monitoringData.count
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    //Returns cell Item -> Text,Image,Design
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Reuse the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! HomeDashboardCollectionViewCell
        
        //Cell button action delegate
        cell.delegate = self as HomeDashboardCollectionViewCellDelegate
        
        //Designing guidlines for cell
        let cornerRadius : CGFloat = 10.0
        //Set backgroundColor for each cell
        //        cell.backgroundColor = UIColor(hex: self.cellBackgroundColour[indexPath.row])
        cell.backgroundColor = UIColor.white
        //Set cornerRadius for each cell
        cell.layer.cornerRadius = cornerRadius
        //cell.layer.borderWidth = 1.5
        //cell.layer.borderColor = UIColorFromHex(rgbValue: UInt32(self.cellBackgroundColour[indexPath.row])).cgColor
        //Set text and image for each cell
        cell.monitoringNames.text = self.monitoringData[indexPath.row]
        //Set the color of the text
        //        cell.monitoringNames.textColor = UIColor.white
        cell.monitoringNames.textColor = UIColor(hex: self.cellBackgroundColour[indexPath.row])
        cell.monitoringImages.image = UIImage(named: self.monitoringImages[indexPath.row])
        //Set circle logo for each cell
        //cell.circleLogo.image = UIImage(named: self.circleLogo[indexPath.row])
        //Set monitoring value
        cell.monitoringValue.textColor =  UIColor(hex: self.cellBackgroundColour[indexPath.row])
        cell.monitoringValue.text = self.monitoringValue[indexPath.row]
        
        //Creating a button
        let measureButton = cell.viewWithTag(1) as! UIButton
       // let borderAlpha : CGFloat = 0.7
        //measureButton.frame = CGRect(x: 0, y: 120, width: 100, height: 30)
        measureButton.setTitle("MEASURE", for: [])
        measureButton.setTitleColor(UIColor.white, for: [])
        measureButton.backgroundColor = UIColor(hex: self.cellBackgroundColour[indexPath.row])
        measureButton.layer.borderWidth = 1.0
        measureButton.layer.borderColor = UIColorFromHex(rgbValue: UInt32(self.cellBackgroundColour[indexPath.row])).cgColor
        //        measureButton.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        measureButton.layer.cornerRadius = cornerRadius
        
        
        
        
        
        return cell
    }
    
    //Returns the selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected row is" ,indexPath.row)
        
        //Instatiate Monitoring Storyboard
        let storyboard = UIStoryboard(name:"MonitoringStoryboard" , bundle:nil)
        
        //If returns fist section (Monitoring)
        if (indexPath.section == 0){
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
            
//            if(indexPath.row == 7){
//                //Navigation Programmitically
//                let MedicineViewController = storyboard.instantiateViewController(withIdentifier: "CholesterolViewController") as! CholesterolViewController
//                self.navigationController?.pushViewController(CholesterolViewController, animated: true)
//            }
        }
            //If return section 1 (Medication)
        else if (indexPath.section == 1){
            //When button clicked navigate to different pages
            if(indexPath.row == 3){
                //Navigation Programmitically
                let BloodPressureViewController = storyboard.instantiateViewController(withIdentifier: "BloodPressureViewController") as! BloodPressureViewController
                self.navigationController?.pushViewController(BloodPressureViewController, animated: true)
            }
        }
        
    }
    
    //Spacing and sizing of grids
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3-5
        let height = collectionView.frame.height/3-1
        return CGSize(width: width, height: height)
    }
    
    //Spacing between each sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    //Spacing between each collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    //Section Header View
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
    //
    //        return sectionHeader
    //    }
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        print("\(monitoringData.count) Sections")
    //        return monitoringData.count
    //    }
    
    //    //Designing a button programmitically
    //    func DesignViewResultsTodayButton(){
    //        let borderAlpha : CGFloat = 0.7
    //        let cornerRadius : CGFloat = 10.0
    //        viewTodayResultsButton.frame = CGRect(x: 250, y: 200, width: 130, height: 30)
    //        viewTodayResultsButton.setTitle("View today", for: [])
    //        viewTodayResultsButton.setTitleColor(UIColor.black, for: [])
    //        viewTodayResultsButton.backgroundColor = UIColor.white
    //        viewTodayResultsButton.layer.borderWidth = 0.5
    //        viewTodayResultsButton.layer.borderColor = UIColor.black.cgColor
    //        viewTodayResultsButton.layer.cornerRadius = cornerRadius
    //        self.view.addSubview(viewTodayResultsButton)
    //    }
    
    //Designing the UIView
    func DesignView(){
        let cornerRadius : CGFloat = 10.0
        overallStatus.backgroundColor = UIColor(hex:0x212121)
        overallStatus.layer.cornerRadius = cornerRadius
    }
    
    //Get today's date
    func getTodayDate() ->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    //Get patient nric
//    func getPatientNric() ->String{
//        let patientNric = "S9822477G"
//        return patientNric
//    }
    
    //    //Check if monitoring record exists if not create one
    //    func checkIfRecordExists(){
    //
    //        let todayDate:String = getTodayDate()
    //        let patientNric:String = getPatientNric()
    //
    //        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve monitoring records
    //        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patientNric) { (monitoring) in
    //                        //Retrieved results from Database
    //                        let retrievedPatientNric = monitoring.nric
    //                        let retrievedDateCreated = monitoring.dateCreated
    //
    //                        //If record exists in database
    //                        if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
    //                            print("record exists")
    //
    //                        //Check if monitored, if monitored change from default logo to tick logo
    //                        if (monitoring.systolicBloodPressure != 0){
    //                           self.monitoringImages[0] = self.monitoredTicks[0]
    //                        }
    //                        if (monitoring.glucose != 0){
    //                            self.monitoringImages[1] = self.monitoredTicks[1]
    //                        }
    //                        if (monitoring.heartRate != 0){
    //                            self.monitoringImages[2] = self.monitoredTicks[2]
    //                        }
    //                        if (monitoring.cigsPerDay != -1){
    //                            self.monitoringImages[3] = self.monitoredTicks[3]
    //                        }
    //                        if (monitoring.bmi != 0){
    //                            self.monitoringImages[4] = self.monitoredTicks[4]
    //                        }
    //                        if (monitoring.totalCholesterol != 0){
    //                            self.monitoringImages[5] = self.monitoredTicks[5]
    //                        }
    //                            //Reload the collection view
    //                            self.CollectionView.reloadData()
    //
    //
    //                            //If values are entered then predictCHD
    //                            if (monitoring.heartRate != 0 && monitoring.diastolicBloodPressure != 0 && monitoring.systolicBloodPressure != 0 && monitoring.glucose != 0 && monitoring.cigsPerDay != -1 && monitoring.bmi != 0 && monitoring.totalCholesterol != 0){
    //                                //Predict CHD
    //                                self.predictCHD(id: monitoring.id, nric: monitoring.nric, gender: monitoring.gender, age: monitoring.age, education: monitoring.education, currentSmoker: monitoring.currentSmoker, cigsPerDay: monitoring.cigsPerDay, bpMedicine: monitoring.bpMedicine, prevalentStroke: monitoring.prevalentStroke, prevalentHypertension: monitoring.prevalentHypertension, diabetes: monitoring.diabetes, totalCholesterol: monitoring.totalCholesterol, systolicBloodPressure: monitoring.systolicBloodPressure, diastolicBloodPressure: monitoring.diastolicBloodPressure, bmi: monitoring.bmi, heartRate: monitoring.heartRate, glucose: monitoring.glucose)
    //                            }
    //                            else{
    //                                self.chdPredictionLabel.text = "NO RISK OF HEART DISEASE"
    //                            }
    //
    //                        }
    //
    //        }
    //   }
    
    //Check if monitoring record exists if not create one
    func checkIfRecordExists(){
        
        //Retrieve from controller to checkIfRecordExists
        MonitoringController().checkIfRecordExists { (monitoring) in
            
            //Check if monitored, if monitored change from default logo to tick logo
            if (monitoring.systolicBloodPressure != 0){
                self.monitoringImages[0] = self.monitoredTicks[0]
            }
            if (monitoring.glucose != 0){
                self.monitoringImages[1] = self.monitoredTicks[1]
            }
            if (monitoring.heartRate != 0){
                self.monitoringImages[2] = self.monitoredTicks[2]
            }
            if (monitoring.cigsPerDay != -1){
                self.monitoringImages[3] = self.monitoredTicks[3]
            }
            if (monitoring.bmi != 0){
                self.monitoringImages[4] = self.monitoredTicks[4]
            }
            if (monitoring.totalCholesterol != 0){
                self.monitoringImages[5] = self.monitoredTicks[5]
            }
            //Reload the collection view
            self.CollectionView.reloadData()
            
            
            //If values are entered then predictCHD
            if (monitoring.heartRate != 0 && monitoring.diastolicBloodPressure != 0 && monitoring.systolicBloodPressure != 0 && monitoring.glucose != 0 && monitoring.cigsPerDay != -1 && monitoring.bmi != 0 && monitoring.totalCholesterol != 0){
                //Predict CHD
                self.predictCHD(id: monitoring.id, nric: monitoring.nric, gender: monitoring.gender, age: monitoring.age, education: monitoring.education, currentSmoker: monitoring.currentSmoker, cigsPerDay: monitoring.cigsPerDay, bpMedicine: monitoring.bpMedicine, prevalentStroke: monitoring.prevalentStroke, prevalentHypertension: monitoring.prevalentHypertension, diabetes: monitoring.diabetes, totalCholesterol: monitoring.totalCholesterol, systolicBloodPressure: monitoring.systolicBloodPressure, diastolicBloodPressure: monitoring.diastolicBloodPressure, bmi: monitoring.bmi, heartRate: monitoring.heartRate, glucose: monitoring.glucose)
            }
            else{
                self.chdPredictionLabel.text = "NO RISK OF HEART DISEASE"
            }
        }
        
        
    } //end of function
    
    
    
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
            self.chdPredictionLabel.text = "RISK OF HEART DISEASE!"
            //Get the CHD value
            chdValue = true
        }
        else{
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
    
    // ========== GOING TO VIRTUAL NURSE CHAT ==========
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChatSegue"
        {
            let chatNav = segue.destination as! ChatNavigationViewController
            chatNav.patient = patient!;
        }
        
    }
    
    
}


//Calling the MonitoringCollectionViewCellDelegate created at MonitoringCollectionViewCell
//Getting the index when each button clicked
extension HomeDashboardViewController: HomeDashboardCollectionViewCellDelegate{
    func didCellButtonTapped(cell: HomeDashboardCollectionViewCell) {
        let item = CollectionView.indexPath(for: cell)
        print("cell selected \(item?.item)")
        
        //Instatiate Monitoring Storyboard
        let storyboard = UIStoryboard(name:"MonitoringStoryboard" , bundle:nil)
        
        //When button clicked navigate to different pages
        if(item!.item == 0){
            //Navigation Programmitically
            let BloodPressureViewController = storyboard.instantiateViewController(withIdentifier: "BloodPressureViewController") as! BloodPressureViewController
            self.navigationController?.pushViewController(BloodPressureViewController, animated: true)
        }
        if(item!.item == 1){
            //Navigation Programmitically
            let GlucoseViewController = storyboard.instantiateViewController(withIdentifier: "GlucoseViewController") as! GlucoseViewController
            self.navigationController?.pushViewController(GlucoseViewController, animated: true)
        }
        if(item!.item == 2){
            //Navigation Programmitically
            let HeartRateViewController = storyboard.instantiateViewController(withIdentifier: "HeartRateViewController") as! HeartRateViewController
            self.navigationController?.pushViewController(HeartRateViewController, animated: true)
        }
        if(item!.item == 3){
            //Navigation Programmitically
            let CigaretteViewController = storyboard.instantiateViewController(withIdentifier: "CigaretteViewController") as! CigaretteViewController
            self.navigationController?.pushViewController(CigaretteViewController, animated: true)
        }
        if(item!.item == 4){
            //Navigation Programmitically
            let BMIViewController = storyboard.instantiateViewController(withIdentifier: "BMIViewController") as! BMIViewController
            self.navigationController?.pushViewController(BMIViewController, animated: true)
        }
        if(item!.item == 5){
            //Navigation Programmitically
            let CholesterolViewController = storyboard.instantiateViewController(withIdentifier: "CholesterolViewController") as! CholesterolViewController
            self.navigationController?.pushViewController(CholesterolViewController, animated: true)
        }
        
        
    }
    
 
    
    
}

