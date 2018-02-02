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
    var patient:Patient?;
    
    //    @IBOutlet weak var viewTodayResultsButton: UIButton!
    @IBOutlet weak var chdPredictionLabel: UILabel!
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var overallStatus: UIView!
    
    //Declaration of variables
    var monitoringData:[String]=["Blood Pressure","Glucose","Heart Rate","Cigarette","BMI","Cholesterol","Medicine Search","Reminder","Add Appointment","View Appointment","Health Data"]
    var monitoringImages: [String] = ["redBloodPressure","blueGlucose","pinkheart","orangeCig","greenWeight","ruler","redBloodPressure","blueGlucose","CreateApp","ViewApp","HealthData"]
    var circleLogo: [String] = ["redOval","blueOval","pinkoval","orangeOval","greenOval","purpleOval"]
    var monitoredTicks: [String] = ["redTick","blueTick","pinkTick","orangeTick","greenTick","purpleTick"]
    var cellBackgroundColour: [Int] = [0xF44336,0x3F51B5,0xE91E63,0xFF9800,0x009688,0x9C27B0
        ,0x2196F3,0x2196F3,0x00BCD4,0x00BCD4,0x00BCD4]
    var monitoringDataValue:[String] = ["0","0","0","0","0","0","0","0","0","0","0"]
    var cigValue:String="0 cigs";
    var monitoringTitle:[String] = ["MEASURE","MEASURE","MEASURE","MEASURE","MEASURE","MEASURE","SEARCH","SET","BOOK","VIEW","CHECK"]
    
    
    
    
    var checkIfMonitored:[String] = []
    var chdValue:Bool = false
    
    struct Storyboard {
        static let sectionHeaderView = "SectionHeaderView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tabcontroller = self.tabBarController as! BaseTabBarViewController;
        tabcontroller.patientDelegate = self;
        
        //Set the delegates of collectionView
        self.CollectionView.delegate = self
        self.CollectionView.dataSource = self
        
        
        //Call the DesignView function
        DesignView()
        
        tabcontroller.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)


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
        
        
        self.navigationController?.navigationBar.topItem?.title = "Home Dashboard"
        
        //reload the collectionView
        checkIfRecordExists()
        
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        print("Logout Button Clicked")
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
        cell.monitoringValue.text = self.monitoringDataValue[indexPath.row]
        
        //Creating a button
        let measureButton = cell.viewWithTag(1) as! UIButton
       // let borderAlpha : CGFloat = 0.7
        //measureButton.frame = CGRect(x: 0, y: 120, width: 100, height: 30)
        measureButton.setTitle(monitoringTitle[indexPath.row], for: [])
        measureButton.setTitleColor(UIColor.white, for: [])
        measureButton.backgroundColor = UIColor(hex: self.cellBackgroundColour[indexPath.row])
        measureButton.layer.borderWidth = 1.0
        measureButton.layer.borderColor = UIColorFromHex(rgbValue: UInt32(self.cellBackgroundColour[indexPath.row])).cgColor
        //        measureButton.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        measureButton.layer.cornerRadius = cornerRadius
        
        return cell
    }
    let MedicationStoryboard = UIStoryboard(name:"MedicationStoryboard" , bundle:nil)
    
    
    //Returns the selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected row is" ,indexPath.row)
        
        //Instatiate Monitoring Storyboard
        let storyboard = UIStoryboard(name:"MonitoringStoryboard" , bundle:nil)
        //Instatiate CreateAppointment Storyboard
        let CreateAppointmentStoryboard = UIStoryboard(name:"CreateAppointmentStoryboard" , bundle:nil)
        //Instatiate ViewAppointment Storyboard
        let ViewAppointmentStoryboard = UIStoryboard(name:"ViewAppointmentStoryboard" , bundle:nil)
        
        
        //If returns fist section (Monitoring)
        if (indexPath.section == 0){
            //When button clicked navigate to different pages
            if(indexPath.row == 0){
                //Navigation Programmitically
                let BloodPressureViewController = storyboard.instantiateViewController(withIdentifier: "BloodPressureViewController") as! BloodPressureViewController
                BloodPressureViewController.patient = patient
                self.navigationController?.pushViewController(BloodPressureViewController, animated: true)
            }
            if(indexPath.row == 1){
                //Navigation Programmitically
                let GlucoseViewController = storyboard.instantiateViewController(withIdentifier: "GlucoseViewController") as! GlucoseViewController
                GlucoseViewController.patient = patient
                self.navigationController?.pushViewController(GlucoseViewController, animated: true)
            }
            if(indexPath.row == 2){
                //Navigation Programmitically
                let HeartRateViewController = storyboard.instantiateViewController(withIdentifier: "HeartRateViewController") as! HeartRateViewController
                HeartRateViewController.patient = patient
                self.navigationController?.pushViewController(HeartRateViewController, animated: true)
            }
            if(indexPath.row == 3){
                //Navigation Programmitically
                let CigaretteViewController = storyboard.instantiateViewController(withIdentifier: "CigaretteViewController") as! CigaretteViewController
                CigaretteViewController.patient = patient
                self.navigationController?.pushViewController(CigaretteViewController, animated: true)
            }
            if(indexPath.row == 4){
                //Navigation Programmitically
                let BMIViewController = storyboard.instantiateViewController(withIdentifier: "BMIViewController") as! BMIViewController
                BMIViewController.patient = patient
                self.navigationController?.pushViewController(BMIViewController, animated: true)
            }
            if(indexPath.row == 5){
                //Navigation Programmitically
                let CholesterolViewController = storyboard.instantiateViewController(withIdentifier: "CholesterolViewController") as! CholesterolViewController
                CholesterolViewController.patient = patient
                self.navigationController?.pushViewController(CholesterolViewController, animated: true)
            }
            if(indexPath.row == 6){
                //Navigation Programmitically
                let MedicineViewController = MedicationStoryboard.instantiateViewController(withIdentifier: "MedicineViewController") as! MedicineViewController
                self.navigationController?.pushViewController(MedicineViewController, animated: true)
            }
            if(indexPath.row == 7){
                //Navigation Programmitically
//              let ReminderViewController = MedicationStoryboard.instantiateViewController(withIdentifier: "ReminderViewController") as! reminderViewTableViewController
//                self.navigationController?.pushViewController(ReminderViewController, animated: true)
            }
            if(indexPath.row == 8){
                //Navigation Programmitically
                let CreateAppointmentViewContoller = CreateAppointmentStoryboard.instantiateViewController(withIdentifier: "doctorViewController") as! doctorViewController
                CreateAppointmentViewContoller.patient = patient
                self.navigationController?.pushViewController(CreateAppointmentViewContoller, animated: true)
            }
            if(indexPath.row == 9){
                //Navigation Programmitically
                let ViewAppointmentViewController = ViewAppointmentStoryboard.instantiateViewController(withIdentifier: "ViewAppointmentViewController") as! ViewAppointmentViewController
                print("viewappointment \(patient)")
                ViewAppointmentViewController.patient = patient
                self.navigationController?.pushViewController(ViewAppointmentViewController, animated: true)
            }
            if(indexPath.row == 10){
                //Navigation Programmitically
                let MonitoringChartsViewController = storyboard.instantiateViewController(withIdentifier: "MonitoringChartsViewController") as! MonitoringChartsViewController
                MonitoringChartsViewController.patient = patient
                self.navigationController?.pushViewController(MonitoringChartsViewController, animated: true)
            }
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
    
    
    //Check if monitoring record exists if not create one
    func checkIfRecordExists(){
        
        //Retrieve from controller to checkIfRecordExists
        MonitoringController().checkIfRecordExists(patient: patient!) { (monitoring) in
            
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
            self.monitoringDataValue.append("")
            self.monitoringDataValue.append("")
            self.monitoringDataValue.append("")
            self.monitoringDataValue.append("")
            self.monitoringDataValue.append("")
            
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
        let finalOutput = round(Double(output[0]))
        
        print(output)
        
        if (finalOutput == 1.0){
            self.chdPredictionLabel.text = "RISK OF HEART DISEASE!"
            //Get the CHD value
            chdValue = true
            
            //Animate the UI view when there is a risk
            UIView.animate(withDuration: 1, animations: {
                self.overallStatus.backgroundColor = UIColor(hex:0xD50000)
                //self.overallStatus.frame.size.width += 10
                //self.overallStatus.frame.size.height += 10
            }) { _ in
                UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
                    self.overallStatus.frame.origin.y -= 20
                })
            }
        }
        else{
            self.chdPredictionLabel.text = "NO RISK OF HEART DISEASE"
            overallStatus.backgroundColor = UIColor(hex:0x212121)
            
            //Get the CHD value
            chdValue = false
        }
        
        //Retrive patient nric and today's date
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = (patient?.NRIC)!
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve specific id in the monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate,patient!) { (monitoring) in
            

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
                MonitoringDataManager().patchMonitoringRecord(self.patient!,azureTableId,updatedParameters, success: { (success) in
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
        if segue.identifier == "MonitoringChartsViewController"
        {
            let monitoringNav = segue.destination as! MonitoringChartsViewController
            monitoringNav.patient = patient!;
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
        
        //Instatiate Medicine Storyboard
        let MedicationStoryboard = UIStoryboard(name:"MedicationStoryboard" , bundle:nil)
        //Instatiate CreateAppointment Storyboard
        let CreateAppointmentStoryboard = UIStoryboard(name:"CreateAppointmentStoryboard" , bundle:nil)
        //Instatiate ViewAppointment Storyboard
        let ViewAppointmentStoryboard = UIStoryboard(name:"ViewAppointmentStoryboard" , bundle:nil)
        
        
        //When button clicked navigate to different pages
        if(item!.item == 0){
            //Navigation Programmitically
            let BloodPressureViewController = storyboard.instantiateViewController(withIdentifier: "BloodPressureViewController") as! BloodPressureViewController
            BloodPressureViewController.patient = patient
            self.navigationController?.pushViewController(BloodPressureViewController, animated: true)
        }
        if(item!.item == 1){
            //Navigation Programmitically
            let GlucoseViewController = storyboard.instantiateViewController(withIdentifier: "GlucoseViewController") as! GlucoseViewController
            GlucoseViewController.patient = patient
            self.navigationController?.pushViewController(GlucoseViewController, animated: true)
        }
        if(item!.item == 2){
            //Navigation Programmitically
            let HeartRateViewController = storyboard.instantiateViewController(withIdentifier: "HeartRateViewController") as! HeartRateViewController
            HeartRateViewController.patient = patient
            self.navigationController?.pushViewController(HeartRateViewController, animated: true)
        }
        if(item!.item == 3){
            //Navigation Programmitically
            let CigaretteViewController = storyboard.instantiateViewController(withIdentifier: "CigaretteViewController") as! CigaretteViewController
            CigaretteViewController.patient = patient
            self.navigationController?.pushViewController(CigaretteViewController, animated: true)
        }
        if(item!.item == 4){
            //Navigation Programmitically
            let BMIViewController = storyboard.instantiateViewController(withIdentifier: "BMIViewController") as! BMIViewController
            BMIViewController.patient = patient
            self.navigationController?.pushViewController(BMIViewController, animated: true)
        }
        if(item!.item == 5){
            //Navigation Programmitically
            let CholesterolViewController = storyboard.instantiateViewController(withIdentifier: "CholesterolViewController") as! CholesterolViewController
            CholesterolViewController.patient = patient
            self.navigationController?.pushViewController(CholesterolViewController, animated: true)
        }
        if(item!.item == 6){
            //Navigation Programmitically
            let MedicineViewController = MedicationStoryboard.instantiateViewController(withIdentifier: "MedicineViewController") as! MedicineViewController
            self.navigationController?.pushViewController(MedicineViewController, animated: true)
        }
        if (item!.item == 7) {
            
            //Navigation Programmitically
//            let ReminderViewController = MedicationStoryboard.instantiateViewController(withIdentifier: "ReminderViewController") as! reminderViewTableViewController
//            self.navigationController?.pushViewController(ReminderViewController, animated: true)
        }
        //reminderViewTableViewController
        if(item!.item == 8){
            //Navigation Programmitically
            let CreateAppointmentViewContoller = CreateAppointmentStoryboard.instantiateViewController(withIdentifier: "doctorViewController") as! doctorViewController
            CreateAppointmentViewContoller.patient = patient
            self.navigationController?.pushViewController(CreateAppointmentViewContoller, animated: true)
        }
        if(item!.item == 9){
            //Navigation Programmitically
            let ViewAppointmentViewController = ViewAppointmentStoryboard.instantiateViewController(withIdentifier: "ViewAppointmentViewController") as! ViewAppointmentViewController
            ViewAppointmentViewController.patient = patient
            self.navigationController?.pushViewController(ViewAppointmentViewController, animated: true)
        }
        if(item!.item == 10){
            //Navigation Programmitically
            let MonitoringChartsViewController = storyboard.instantiateViewController(withIdentifier: "MonitoringChartsViewController") as! MonitoringChartsViewController
            MonitoringChartsViewController.patient = patient
            self.navigationController?.pushViewController(MonitoringChartsViewController, animated: true)
        }

    }
}

//PASS PATIENT DATA TO TAB CONTROLLER
extension HomeDashboardViewController:PatientDelegate
{
    func getPatient() -> Patient {
        return patient!;
    }
}

