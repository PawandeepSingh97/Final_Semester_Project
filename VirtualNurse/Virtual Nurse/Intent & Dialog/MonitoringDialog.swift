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
    //let monitorModel:Monitoring?;
    
    init(dialogToCall:String,patient:Patient) {
        super.init(dialogToCall: dialogToCall)
        self.patient = patient;
        //monitorModel = Monitoring
    }
    func getMonitoring()
    {
        //get stuff thats havent log yet
        //display meesage
        
        let todisplay = "Okay, your appointment is not cancelled."
        let botReply = todisplay;
        
        self.responseToDisplay.append(todisplay)
        self.BotResponse.append(botReply)
        
        
    }
    
    //create func to call from db
    func check()
    {
        var loggedCounter:Int = 0;
        var itemsNotLogged:[String] = [];
        
        //call the controller
        monitorController.checkIfRecordExists { (Monitoring) in
            //Put if else
            //Virtual NurseLogic
            //Check which monitoring values are not log
            if (Monitoring.systolicBloodPressure != 0){ // !=0 means log already
                loggedCounter += 1;
            }
            if (Monitoring.glucose != 0){
                loggedCounter += 1;
            }
            if (Monitoring.heartRate != 0){
                loggedCounter += 1;
            }
            if (Monitoring.cigsPerDay != -1){
               loggedCounter += 1;
            }
            if (Monitoring.bmi != 0){
                loggedCounter += 1;
            }
            if (Monitoring.totalCholesterol != 0){
                loggedCounter += 1;
            }
        }
    }
    
}
