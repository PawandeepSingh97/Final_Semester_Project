//
//  Dialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 10/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation
import UIKit

protocol PromptAnsweredDelegate {
    //DELEGATE WILL PASSED WHEN BOT REPLIES WITH A PROMPT QUESTION
    func User(hasAnswered:String,dialog:Dialog);
}

class Dialog:NSObject
{
    var Intent: String { get { return "Dialog" } }
    var paDelegate:PromptAnsweredDelegate?;
    
    //Store patient data
    var patient:Patient?;

    //stores the entity value
    var entity:Entity?
    {
        didSet{//once got entity
            //convert dates from entity to date
            convertStringToDate();
            print("DID SET ***************")
        }
    }
    var dates:[Date] = [];
    
    
    var dialog:String;//Stores what dialogtocall
    var responseToDisplay:[String] = [];
    var isPrompt:Bool = false;
    var BotResponse:[String] = [];

    //var entities:[JSON]?;//store the entities data
    
    
    
    init(dialogToCall:String){
        self.dialog = dialogToCall;
    }
    
    open func getDialog()
    {
        responseToDisplay.append(error())
        BotResponse.append(error());
        //return responseToDisplay;
    }
    
    //HANDLE ERROR BY CREATING AN ERROR DIALOG
    open func error() -> String {
        return "Sorry, I didn't quite get that.\n Could you say that again ? ";
    }
    
    //This will cast the dialog as its original cast type
     func castDialog() -> Dialog
    {
        
        //get type of current instance
        switch Intent {
        case "Appointment":
            return self as! AppointmentDialog;
        default:
            return self;
        }
        
    
    }
    
    
    @objc open func promptHandler(sender:UIButton)
    {
        print("defulat handler for dialog")
        paDelegate?.User(hasAnswered: "no answer", dialog: self);
    }
    
    internal func convertStringToDate(){

       // var dates:[Date] = [];
        let df = DateFormatter();
        df.dateFormat = "yyyy-MM-dd"//ORIGINAL FORMAT IN THE DATE STRING
        
        dates = [];
        if let en = self.entity
        {
            if en.entityType == "date" || en.entityType == "daterange"
            {
                for stringdates in en.entityValues!
                {
                    print("************** DATES ARE \(stringdates)")
                    
                    let date = df.date(from: stringdates)!;
                    print(date.debugDescription)
                    self.dates.append(date);
                    //print("**************** DATES formated ARE \(date?.debugDescription)")
                }
            }
            
            
        }
    }
    
    func getDatesFromUtterances() -> (start:Date,end:Date)
    {
        var startDate = Date();
        var endDate = Date();
        

            //get the dates and place dates in methods
            if dates.count == 2
            {
                startDate = dates[0];
                endDate = dates[1];
                return (startDate,endDate);
            }
            else if dates.count == 1
            {
                startDate = dates[0];
                endDate = dates[0];
                print("THERE ARE \(dates.count) DATES FROM ENTITY");
                return (startDate,endDate);
            }
        return (startDate,endDate);
    }
    
    
}
