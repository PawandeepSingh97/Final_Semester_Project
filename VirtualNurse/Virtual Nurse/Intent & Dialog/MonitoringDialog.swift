//
//  MonitoringDialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 30/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation


class MonitoringDialog:Dialog
{
    
    
    override var Intent: String { get { return "Monitoring" } }
    private let monitorController = MonitoringController();
    private var itemsnotLogged:[String] = [];
    private var loggedCounter:Int = 0;
    
    //let monitorModel:Monitoring?;
    
    init(dialogToCall:String,patient:Patient) {
        super.init(dialogToCall: dialogToCall)
        self.patient = patient;
        
    }
    
    override func getDialog() {
        switch self.dialog {
        case "Get":
           checkMonitoring();
        default:
            self.responseToDisplay.append(error())
            self.BotResponse.append(error())
            brDelegate?.Nurse(response: self);
        }
    }
    
    func getMonitoring(_ loggedcounter:Int,_ itemsNotLogged:[String])
    {
        //get stuff thats havent log yet
        //display meesage
        
            //print("GET MONITORING CALLED FIRST A ALREADY");
            var message = "";
            if loggedcounter == 6
            {
                message = "Great Job! You have logged all your health.\n Make sure to regulary logged them too.";
                self.responseToDisplay.append(message)
                self.BotResponse.append(message)
            }
            else if loggedcounter == 4
            {
                message = "You have logged most of your readings, your only missing \(itemsNotLogged[0]) and \(itemsNotLogged[1]).\n Don't forget to log them soon.";
                self.responseToDisplay.append(message)
                self.BotResponse.append(message)
            }
            else if loggedcounter > 0
            {
                message = "You haven't logged most of your health intake. Don't forget to update them soon.";
                self.responseToDisplay.append(message)
                self.BotResponse.append(message)
            }
            else if loggedcounter == 0 //if never logged at all
            {
                message = "You haven't log any of your health intake. Don't forget to update them soon.";
                self.responseToDisplay.append(message)
                self.BotResponse.append(message)
            }
        
        //PASS DIALOG TO DELEGATE
        //DOING CAN DISPLAY MESSAGE AFTER GETTING CONTENT FROM DB
        brDelegate?.Nurse(response: self);
        
    }
    

    
    //create func to call from db
   private func checkMonitoring()
    {
        //var loggedCounter:Int = 0;
        //var itemsNotLogged:[String] = [];
    
        //call the controller
        monitorController.checkIfRecordExists(patient: self.patient!) { (Monitoring) in
            //Put if else
            //Virtual NurseLogic
            //Check which monitoring values are not log
            if (Monitoring.systolicBloodPressure != 0){ // !=0 means log already
                self.loggedCounter += 1;
                print("LOG BLOOD PRESSURE ALREADY ")
            }
            else {
                self.itemsnotLogged.append("Blood Pressure")
                print("NEVER LOG BLOOD PRESSURE ALREADY ")
            }
            if (Monitoring.glucose != 0){
                self.loggedCounter += 1;
                
            }
            else{
                self.itemsnotLogged.append("Glucose")
            }
            if (Monitoring.heartRate != 0){
                self.loggedCounter += 1;
                
            }
            else
            {
                 self.itemsnotLogged.append("Heart Rate")
            }
            if (Monitoring.cigsPerDay != -1){
               self.loggedCounter += 1;
                
            }
            else
            {
                 self.itemsnotLogged.append("Ciggerate")
            }
            if (Monitoring.bmi != 0){
                self.loggedCounter += 1;
                
            }
            else
            {
                 self.itemsnotLogged.append("BMI")
            }
            if (Monitoring.totalCholesterol != 0){
                self.loggedCounter += 1;
                
            }
            else{
                 self.itemsnotLogged.append("Cholesterol Intake")
            }
            
            //ONCE GOT DATA FROM MONITORING DB
            //CALL THE DIALOG TO DISPLAY MESSAGE AND ITS CONTENT
            self.getMonitoring(self.loggedCounter, self.itemsnotLogged);
            
        }
    }
    
}

