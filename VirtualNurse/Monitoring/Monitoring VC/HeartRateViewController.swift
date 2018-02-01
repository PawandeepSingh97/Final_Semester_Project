//
//  HeartRateViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 31/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import HealthKit
import Alamofire

class HeartRateViewController: UIViewController {
    

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var maxHeartRate: UILabel!
    @IBOutlet weak var minHeartRate: UILabel!
    @IBOutlet weak var displayHeartRate: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var patient:Patient?;
    
    //To interact with the healthkit framework
    let healthStore = HKHealthStore()
    
    //Define which piece of information we want to read/write
    let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
    
    //Store HeartRate in an array
    var storeHeartRate:[Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call DesignSubmitButton Function
        DesignSubmitButton()
        
        //Show/Hide the button based on wheather the healthdata is available on the device
        submitButton.isHidden = !HKHealthStore.isHealthDataAvailable()

        //Set Date for dateLabel
        setDateLabelCurrentDate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //Hide the tab bar
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //Show the tab bar
        self.tabBarController?.tabBar.isHidden = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        print("Submit button clicked")
        //Retrive patient nric and today's date
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = (patient?.NRIC)!
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve specific id in the monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patient!) { (monitoring) in
            //Retrieved results from Database
            let retrievedPatientNric = monitoring.nric
            let retrievedDateCreated = monitoring.dateCreated
            
            print("1\(retrievedPatientNric == patientNric)")
            print("2\(retrievedDateCreated == todayDate)")
            
            //If record exists in database
            if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
                //print("record exists")
                print("GO AND DIE")
                
                //Get the azure table unique id
                let azureTableId = monitoring.id
                
                //Get the heartRate value
                var heartRateValue = Double(self.displayHeartRate.text!)
               
                
                //Check if heart rate is clocked in
                if (heartRateValue! > 0.0){
    
                    //Declare updated parameters
                    let updatedParameters: Parameters = [
                        "heartRate": heartRateValue!,
                        ]
                    
                    //Update the heartRate in the monitoring record
                    MonitoringDataManager().patchMonitoringRecord(self.patient!,azureTableId,updatedParameters, success: { (success) in
                        print(success)
                    }) { (error) in
                        print(error)
                    }
                    
                    //Check if heart rate is in healthy range
                    if (heartRateValue! >= 60.0 && heartRateValue! <= 100.0){
                        self.showAlert(message: "Good Job! You have a healthy heart rate.")
                    }
                    else{
                        self.showAlert(message: "Please keep yourself healthy. You have a unhealthy heart rate")
                    }
                    
                }
                else{
                    self.showAlert(message: "Please clock in your heart rate again.")
                }
            }
        }
        
        
        
    }
    
    @IBAction func syncAppleWatchButton(_ sender: Any) {
        print("Sync button clicked")
        
        //Retrieve Heart Rate
        retrieveHeartRate()
    }
    
    @IBAction func viewChartsButton(_ sender: Any) {
        
        //Instatiate Monitoring Storyboard
        let storyboard = UIStoryboard(name:"MonitoringStoryboard" , bundle:nil)
        //Navigation Programmitically
        let ManualHeartRateViewController = storyboard.instantiateViewController(withIdentifier: "ManualHeartRateViewController") as! ManualHeartRateViewController
        self.navigationController?.pushViewController(ManualHeartRateViewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
       //Return to the main monitoring dashboard
       navigationController?.popViewController(animated: true)
    }
    
    //Designing a button programmatically
    func DesignSubmitButton(){
        //let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        submitButton.frame = CGRect(x: 7, y: 660, width: 400, height: 50)
        submitButton.setTitle("Submit", for: [])
        submitButton.setTitleColor(UIColor.white, for: [])
        submitButton.backgroundColor = UIColor(hex: 0xE91E63)
        submitButton.layer.cornerRadius = cornerRadius
        self.view.addSubview(submitButton)
    }
    
    //Getting current date time
    func getCurrentLocalDate()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    //Setting date for label
    func setDateLabelCurrentDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        let str = formatter.string(from: date)
        dateLabel.text = str
    }
    
    //Show Alert
    func showAlert(message: String){
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "Heart Rate Monitoring", message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Retrieve Heart Rate thru healthKit
    func retrieveHeartRate(){
        
        //Setting Date
        let calendar = NSCalendar.current
        let now = NSDate()
        //let components = calendar.dateComponents([.year,.month,.day], from: now as Date)
        
//        guard let startDate = calendar.date(from: components) else {
//            fatalError("*** Unable to create the start date ***")
//        }
        
        //Minus 1 day of user date time
        let previousDateTime = calendar.date(byAdding: .day, value: -1, to: self.getCurrentLocalDate())
        
        //Predicate -> Filtering of data by date
//        let predicate = HKQuery.predicateForSamples(withStart: previousDateTime , end: self.getCurrentLocalDate() , options: .strictEndDate)
        
        //Sorting the data -> with latest one at the top
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        //To authorize healthkit in app
        healthStore.requestAuthorization(toShare: [], read: [type!]) { (success, error) -> Void in
            if success {
                print("success")
                
                let q = HKSampleQuery(sampleType: self.type!, predicate: nil, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor], resultsHandler: {query,results, error in
          
                    guard let samples = results as? [HKQuantitySample] else {
                        fatalError("An error occured fetching the user's tracked heart rate")
                    }
                    
                    //Getting the user Date Time
                    let UserDateTime = self.getCurrentLocalDate()
                    print("\(UserDateTime) User Date Time")
                   
                    //Adding 2 mins to the user time
                    let calendar = Calendar.current
                    let addUserTime = calendar.date(byAdding: .minute, value: 2, to: UserDateTime)
                    
                    //Minus 2 mins to the user time
                    let minusUserTime = calendar.date(byAdding: .minute, value: -2, to: UserDateTime)
                    
                    //Print Statments
                    print("\(String(describing: addUserTime)) Add")
                    print("\(String(describing: minusUserTime)) Minus")
                    print("\(String(describing: previousDateTime)) Previous")
                    
                    
                    //Update the UI
                    DispatchQueue.main.async() {
                        
                        //Loop the HkSamples
                        for result in samples {

                            //If the user's heartRate dateTime is within the range
                            if (result.endDate >= minusUserTime! && result.endDate < addUserTime!){
                                print("Retriving")
                                
                                //Extract the quantity,date,heartrate
                                let quantity = result.quantity
                                //let startdate = result.endDate
                                let count = quantity.doubleValue(for: HKUnit(from: "count/min"))
                                
                                //Store heartrate in an array
                                self.storeHeartRate.append(count)
                                
                                //Calculate Maximum heartrate
                                let maximumHeartRate = self.storeHeartRate.max()
                                self.maxHeartRate.text = String("Max \(Int(maximumHeartRate!))")
                                
                                //Calculate Minimum heartrate
                                let minimumHeartRate = self.storeHeartRate.min()
                                self.minHeartRate.text = String("Min \(Int(minimumHeartRate!))")
                                
                                //Calculate Average heartrate
                                let sumHeartRate = self.storeHeartRate.reduce(0, +)
                                let avgHeartRate = sumHeartRate / Double(self.storeHeartRate.count)
                                self.displayHeartRate.text = String(Int(avgHeartRate))
                            }
                            
                        }

                    } // Updating the UI Ends here
                    
                    
                })
                
                self.healthStore.execute(q)
                
            } else {
                print("failure")
            }
            
            if let error = error { print(error) }
        }
    }

}


extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}
