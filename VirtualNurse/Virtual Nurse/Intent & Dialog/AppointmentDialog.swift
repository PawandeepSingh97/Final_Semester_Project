//
//  AppointmentDialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 10/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class AppointmentDialog:Dialog {
    
     override var Intent: String { get { return "Appointment" } }
    
    var appointment:AppointmentModel?;
    var appointmentList : [AppointmentModel] = []
    
    init(dialogToCall:String,patient:Patient) {
        super.init(dialogToCall: dialogToCall)
        self.patient = patient;
    }
    
    override func getDialog() {
        
        let dates = getDatesFromUtterances();
//        print(dates.start.debugDescription)
//        print(dates.end.debugDescription)
    
        switch self.dialog {
        case "Get":
            getAppointment(starting: dates.start, ending: dates.end);
        case "Cancel":
            cancelAppointment(start:dates.start,end:dates.end);
        default:
            self.responseToDisplay.append(error())
            self.BotResponse.append(error())
        }
    }
    
//================================================================================================================================================
    
    func getAppointment(starting:Date,ending:Date){
        
        var datereply  = " ";
        if let en = entity {
            datereply = " for \(en.entityFromUtterence!) ";
        }
        else
        {
            datereply = " ";
        }
        
        //means is one date only
        if starting == ending
        {
            getAppointment(start: starting, end: ending, issame: true);
            //call required method to get appointment details
        }
        else if starting != ending { //means is a date range (e.g when user ask for next week appointment)
            // call required method to get appointment details
            //if have appointment but is not next week
            //show message to first say, you have no appointment this week but you have an appointment on...
            getAppointment(start: starting, end: ending, issame: false);
            //
        }
        
        //TODO: ONCE GET APPOINTMENT DETAILS, HAVE A METHOD TO READ STRING AS THOUGH A NURSE IS READING IT
        
        let toDisplay = "Your appointment\(datereply)is in 12/12/2018 and is with dr.Tan";
        let botReply = toDisplay;
        
        self.responseToDisplay.append(toDisplay)
        self.BotResponse.append(botReply)
        //return ("Your appointment is in 12/12/2018");
    }
    
//================================================================================================================================================
    
    //WHEN PATIENT ONCE TO CANCEL APPOINTMENT
    // NURSE WILL PROMPT IF WANT TO CANCEL FIRST
    func cancelAppointment(start:Date,end:Date)
    {
        //CHECK IF GOT APPOINTMENT FIRST
        //IF HAVE, THEN CAN ASK TO PROMPT TO CANCEL
        //FROM THERE, GET PATIENT FEEDBACK IF WANT TO CANCEL,
        getAppointment(starting: start, ending: end);

        self.isPrompt = true;//tells dialog it is a prompt questions
        
        //prompt question
        let todisplay = "Are you sure you want to cancel your appointment ? ";
        let botReply = todisplay;
        //no need to call db here
        
        self.responseToDisplay.append(todisplay)
        self.BotResponse.append(botReply)
        
        
        //ELSE IF DON'T HAVE,TELL PATIENT YOU HAVE NO APPOINTMENT TO CANCEL
    }
    
    func cancelAppointmentYES()
    {
        //method to call to cancel appointment
        
        let todisplay = "Okay, your appointment has been cancelled ";
        let botReply = todisplay;
        
        self.responseToDisplay.append(todisplay)
        self.BotResponse.append(botReply)
        
    }
    
    func cancelAppointmentNO()
    {
        //do nothing,just display message
        
        let todisplay = "Okay, your appointment is not cancelled."
        let botReply = todisplay;
        
        self.responseToDisplay.append(todisplay)
        self.BotResponse.append(botReply)
    }
    
//================================================================================================================================================
    /*
     GOING TO BE DIFFICULT
     :(
     TODO:MAKE USE OF STACKVIEW TO DISPLAY DATES AVAILABLE ?
     : FROM THERE, BUTTON TO GET DATE TIME AND UPDATE
     */
    func updateAppointment()
    {
        
    }
    
    func updateAppointmentTo(date:Date){}
    
    func updateAppointmentYes(){}
    
    func updateAppointmentNo(){}
    
    func getAppointment(start:Date,end:Date,issame:Bool){
        AppointmentDataManager().getAppointmentByNRIC((patient?.NRIC)!) { (Appointment) in
            
            print("enter here \(Appointment.date)")
            
    self.appointmentList.append(AppointmentModel(Appointment.id,Appointment.nric,Appointment.doctorName,Appointment.date,Appointment.time));
            

            if issame //asking if got appointment on a particualt date
            {
                
                //check if date is in appointmentlist
                //if have, return the appointment
                for appt in self.appointmentList{
                    print("****************date \(appt.date) **********************");
                    
                }
            }
            else { //asking if got appointment in a week range
                //check if appointment is inside the start and end date range
                
            }

           
        }
    }
    
//================================================================================================================================================
    
//    private func readDate() -> String
//    {
//        let test = "12 December 2018";
//        return test;
//    }
    
    
    
    /*
     Ovveride prompt handler for appoinment
     */
   @objc override func promptHandler(sender:UIButton)
    {
        let text = sender.titleLabel?.text!
        print("Appointment prompt handler tapped");
        
        if  text == "YES"{
            cancelAppointmentYES();//DISPLAY REQUIRED MESSAGE
            
            //PASS MESSAGE AND DELEGATE TO NOTIFY PATIENT
            paDelegate?.User(hasAnswered: text!, dialog: self)
            print("YES")
        }
        else
        {
            cancelAppointmentNO();//DISPLAY REQUIRED MESSAGE
            //PASS MESSAGE AND DELEGATE TO NOTIFY PATIENT
            paDelegate?.User(hasAnswered: text!, dialog: self)
             print("NO")
        }
    }
    
    
//****************TAUFIK*****************
    //TODO, CREATE A FUNCTION , THAT TAKES IN 2 DATES TO CHECK IF AN APPOINTMENT IS WITHIN THE 2 DATES SPECIFIED
                // IF POSSIBLE, WILL BE GREAT IF CAN GET WHO IS THE DOCTOR FOR THAT APPOINTMENT AS WELL
    
    //TODO, CREATE ANOTHER FUNCTION TO CANCEL APPOINTMENT,
    
    //TODO, CREATE ANOTHER FUNCTION TO UPDATE APPOINTMENT

}
