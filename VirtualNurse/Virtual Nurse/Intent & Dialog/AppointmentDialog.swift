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
    

    var appointmentList : [AppointmentModel] = [];

    var appointment:AppointmentModel?;
    
    init(dialogToCall:String,patient:Patient) {
        super.init(dialogToCall: dialogToCall)
        self.patient = patient;
        
        
    }
    
    override func getDialog() {
        
        let dates = getDatesFromUtterances();

    
    
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
        if let en = entity { //if have entity
            
            
            datereply = "for \(en.entityFromUtterence!)";
            
            //means is one date only
            if starting == ending
            {
                checkAppointment(hasDate: true, start: starting, end: ending, issame: true,datereply:datereply);
                //call required method to get appointment details
            }
            else if starting != ending { //means is a date range (e.g when user ask for next week appointment)
                // call required method to get appointment details
                //if have appointment but is not next week
                //show message to first say, you have no appointment this week but you have an appointment on...
                checkAppointment(hasDate: true, start: starting, end: ending, issame: false,datereply:datereply);
                //
            }
            
        }
        else
        {
            datereply = "";
            checkAppointment(hasDate: false, start: Date(), end: Date(), issame: false,datereply:datereply);
        }
        
        
        
       
        
        //TODO: ONCE GET APPOINTMENT DETAILS, HAVE A METHOD TO READ STRING AS THOUGH A NURSE IS READING IT
        
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
        self.BotResponse.append(botReply);
        
        
        
        //self.brDelegate?.Nurse(response: self);
        
        
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
    
    
//================================================================================================================================================
    

    
    
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
    
    
    
    private func checkAppointment(hasDate:Bool,start:Date,end:Date,issame:Bool,datereply:String){
        AppointmentDataManager().getAppointmentByNRIC((patient?.NRIC)!) { (appointment) in
            
            var appt = AppointmentModel(appointment.id,appointment.nric,appointment.doctorName,appointment.date,appointment.time);
            
            self.appointmentList.append(appt);
            print(appt.nric);
        
            for appointment in self.appointmentList
            {
                
                if hasDate //IF HAS ENTITY
                {
                    if issame //asking if got appointment on a particular date
                    {
                        //check if date is in appointmentlist
                        //if have, return the appointment
                        let formattedapptDate = self.convertDateFrom(appointment.date)
                        if start == formattedapptDate
                        {
                            //if there is an appointment on the date specified
                            //display message
                            let toDisplay = "You do have an appointment \(datereply) which is on the \(appointment.date) at \(appointment.time) with \(appointment.doctorName)";
                            let botReply = toDisplay;
                            
                            self.responseToDisplay.append(toDisplay)
                            self.BotResponse.append(botReply)
                            self.brDelegate?.Nurse(response: self);
                            break;
                        }
                        else
                        {
                            //if not display message, don't have appointment for that day
                            // but have appointment on ....
                            let toDisplay = "You do not have an appointment \(datereply) but have one which is on the \(appointment.date) at \(appointment.time) with \(appointment.doctorName)";
                            let botReply = toDisplay;
                            
                            self.responseToDisplay.append(toDisplay)
                            self.BotResponse.append(botReply)
                            self.brDelegate?.Nurse(response: self);
                            break;
                        }
                        
                        
                    }
                    else
                    { //asking if got appointment in a week range
                        //check if appointment is inside the start and end date range
                        
                    }
                }
                else //IF NOT ENTITY
                {
                   // let formattedapptDate = self.convertDateFrom(appointment.date)
                    let toDisplay = "You have an appointment \(datereply) which is on the \(appointment.date) at \(appointment.time) with \(appointment.doctorName)";
                    let botReply = toDisplay;
                    
                    self.responseToDisplay.append(toDisplay)
                    self.BotResponse.append(botReply)
                    self.brDelegate?.Nurse(response: self);
                    break;
                }
                
                
            }//end for loop
            
            //if got no appointment;
            if self.appointmentList.count == 0
            {
                let toDisplay = "You do not have any appointment at this time";
                let botReply = toDisplay;
                
                self.responseToDisplay.append(toDisplay)
                self.BotResponse.append(botReply)
                self.brDelegate?.Nurse(response: self);
            }
            
            print("got appointment for \(self.responseToDisplay.last!)");
            
        }
    }
    
    private func convertDateFrom(_ string:String) -> Date
    {
        let formatter = DateFormatter();
        formatter.dateFormat = "dd/MM/yyyy";
        let date = formatter.date(from: string)!;
        return date;
    }
    
    //TODO, CREATE ANOTHER FUNCTION TO CANCEL APPOINTMENT,
    
    //TODO, CREATE ANOTHER FUNCTION TO UPDATE APPOINTMENT

}
