//
//  GreetingDialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 1/2/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation


class GreetingDialog:Dialog
{
    override var Intent: String { get { return "Greeting" } }
    
    init(dialogToCall:String,patient:Patient) {
        super.init(dialogToCall: dialogToCall)
        self.patient = patient;
    }
    
    
    override func getDialog() {
        
        //if patient say hi,
        // will say hi and other things
        
        //if patient says anything for me ?
        // will just get everything
        switch self.dialog
        {
        case "Hello":
            greetPatient();
        case "Info":
            greetPatient();
            getAppointment();
            getMonitoringLog();
        default:
            self.responseToDisplay.append(error())
            self.BotResponse.append(error())
        }
        

        
    }
    
    func greetPatient()
    {
        let toDisplay = "Hello \(patient!.name)";
        let botReply = toDisplay;
        
        self.responseToDisplay.append(toDisplay)
        self.BotResponse.append(botReply);
        print("\(responseToDisplay[0])");
        brDelegate?.Nurse(response: self);
    }
    
    /**
     
     WILL CALL OTHER DIALOGS
     */
    
    func getAppointment()
    {
        _ = AppointmentDialog(dialogToCall: dialog, patient: patient!);
        //apptdialog.getAppointment(starting: , ending: )
        
        self.responseToDisplay.append("appointment greet is in test")
        self.BotResponse.append("still in test");
        
    }
    
    func getMonitoringLog()
    {
        self.responseToDisplay.append("monitoring greet is in test")
        self.BotResponse.append("still in test");
        
    }
    
    func getMedication()
    {
        self.responseToDisplay.append("medication greet is in test")
        self.BotResponse.append("still in test");
    }
    
    //get appointment
    
    //get monitoring log

    //get medication
   
}
