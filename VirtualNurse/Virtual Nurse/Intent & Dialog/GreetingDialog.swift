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
    
    var apptDialog:AppointmentDialog?;
    var monitoringDialog:MonitoringDialog?;
    var medicationDialog:MedicationDialog?;
    
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
            getInfo();
        case "ThankYou":
            replyThankYou();
        default:
            self.responseToDisplay.append(error())
            self.BotResponse.append(error())
        }
        

        
    }
    
    func replyThankYou()
    {
        let localecode = UserDefaults.standard.value(forKey: "language") as! String;
        if (localecode == nil || localecode == "en")
        {
            self.responseToDisplay.append("Your Welcome");
            self.BotResponse.append("Your Welcome");
            print("\(responseToDisplay[0])");
            brDelegate?.Nurse(response: self);
        }
        else{
            MT.Translate(from: "en", to: localecode, text: "Your Welcome", onComplete: { (convertedText) in
                self.responseToDisplay.append(convertedText)
                self.BotResponse.append(convertedText);
                //print("\(responseToDisplay[0])");
                self.brDelegate?.Nurse(response: self);
            })
        }
    }
    
    func getInfo()
    {
        greetPatient();
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:1)!, repeats: false) { (_) in
            
            self.getAppointment();
            self.apptDialog?.paDelegate = self.paDelegate
            self.apptDialog?.brDelegate = self.brDelegate
            self.apptDialog?.getDialog();
            
            //self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
            Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:7)!, repeats: false) { (_) in
                
                //self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
                self.getMonitoringLog();
                self.monitoringDialog?.paDelegate = self.paDelegate;
                self.monitoringDialog?.brDelegate = self.brDelegate;
                self.monitoringDialog?.getDialog();
                //self.isGreetingDialog = false;
                
            }
            
        };
        
        
       // getAppointment();
        //getMonitoringLog();
        
    }
    
    func greetPatient()
    {
        let toDisplay = "Hello \(patient!.name)";
        let botReply = toDisplay;
        
        
        let localecode = UserDefaults.standard.value(forKey: "language") as! String;
        if (localecode == nil || localecode == "en")
        {
            self.responseToDisplay.append(toDisplay)
            self.BotResponse.append(botReply);
            print("\(responseToDisplay[0])");
            brDelegate?.Nurse(response: self);
        }
        else{
            
            
            MT.Translate(from: "en", to: localecode, text: toDisplay, onComplete: { (convertedText) in
                self.responseToDisplay.append(convertedText)
                self.BotResponse.append(convertedText);
                //print("\(responseToDisplay[0])");
                self.brDelegate?.Nurse(response: self);
            })
        }
        
        
    }
    
    /**
     
     WILL CALL OTHER DIALOGS
     */
    
    func getAppointment()
    {
        apptDialog = AppointmentDialog(dialogToCall: "Get", patient: patient!);
        //appt.brDelegate = self.brDelegate;
        //appt.paDelegate = self.paDelegate;
        
        
    }
    
    func getMonitoringLog()
    {
        monitoringDialog = MonitoringDialog(dialogToCall: "Get", patient: patient!);
        //monitordialog.brDelegate = self.brDelegate;
        //monitordialog.paDelegate = self.paDelegate;
        //monitoringDialog?.getDialog();
    }
    
    func getMedication()
    {
        self.responseToDisplay.append("If you are not sure what medicine you are holding. Just ask I am here to help")
        self.BotResponse.append("If you are not sure what medicine you are holding. Just ask I am here to help");
    }
    
    //get appointment
    
    //get monitoring log

    //get medication
   
}
