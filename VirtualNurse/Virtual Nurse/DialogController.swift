//
//  DialogController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 4/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

protocol BotResponseDelegate:class
{
    
    //Function to get the dialog after patient query
    func display(response:Dialog);
    
    //function calls when dialog is prompt question
    func isPromptQuestion(promptDialog:Dialog);
    
    func recievedPromptResponse(responseDialog:Dialog);
    
    func receivedMedication(responseDialog:MedicationDialog);
    
    
}



//Dialog Controller will interact with viewController,dialog and LUIS endpoint
class DialogController: NSObject {
    
    var patient:Patient?;
    var Botdelegate:BotResponseDelegate!;
    
    //STORES CONVERSATION AND ITS ENTITIES
    var conversationContext = ConversationStack();
    
    
    
    //TALK TO LUIS
     func query(text:String)
    {
        LUISDataManager.queryLUIS(query: text) { (intent) in
            //Once determine INTENT FROM LUIS
            intent.processIntent();//will determine topic and dialog
            
            let entity =  intent.processEntity();
            
            let topic = intent.topic!;
            let dialog = intent.dialog!;
//            let entities = intent.entities;
            print("topic is \(topic)");
            print("dialog to call for \(topic) is \(dialog)");
            
           // let entities = intent.entities;
            
            self.addDialogToConversation(topic, dialogToCall: dialog,entity:entity);
            let response = self.dialogToRespond();
            response.paDelegate = self;//set delegate of prompt here
            response.brDelegate = self;
            response.getDialog();//this will update the variables in dialog to display in UI or for bot to speak
          
            

            //onComplete?(response);
        }
    }
    
    
    
    //This will display string to UI
    private func dialogToRespond() -> Dialog
    {
        let dialog = conversationContext.peek()!;
       // dialog.entities = conversationContext.entities;
        
        return dialog;
    }
    
    //check stack maintains conversation
    //step1.1:ensure that conversation is within the same topic
    //else remove all the entire elements in stack
    private func checkContext(elementToAdd:Dialog,entity:Entity?,hasEntity:Bool,topic:String,iserrordialog:Bool)
    {
     //CHECK IF LAST ELEMENT MATCHES TYPE OF ELEMENT THAT IS ABOUT TO BE ADDED
        //IF THE TYPE IS SAME,ADD TO STACK
        // IF TYPE IS DIFFERENT, REMOVE ALL ELEMENTS IN STACK AND ADD AGAIN
        
        if conversationContext.count() == 0
        {
            if hasEntity
            {
                //add entity to dialog
                elementToAdd.entity = entity;
            }
            conversationContext.push(elementToAdd);
        }
        else // if got dialog in stack
        {
            let recentdialog = conversationContext.peek()!; //get recent dialog
            let rdtype = type(of: recentdialog); //get type of recent dialog
            
            let typeOfElement = type(of: elementToAdd); // get type of dialog to add
            
            if rdtype == typeOfElement || hasEntity   // if both are of the same type, or if there is an entity
            {

                //no need add entity,, can make use of previous dialog only if topic is none and call method using recent added entities
                
                if topic == "None"
                {
                    let lastdialog = conversationContext.pop();
                    lastdialog?.BotResponse = [];
                    lastdialog?.responseToDisplay = [];
                    lastdialog?.entity = entity;
                    conversationContext.push(lastdialog!)
                }
                else
                {
                    
                    
                    elementToAdd.entity = entity;
                    conversationContext.push(elementToAdd);
                    
                }
                
               
                //conversationContext.entities?.append(entity) //add entity as well
                print(" \(typeOfElement)");
            }
            else //if different type
            {
                conversationContext.removeAll(); //remove all item in stack
                
                if hasEntity
                {
                    elementToAdd.entity = entity;
                }
                if iserrordialog //if is an error dialog
                {
                    let lastdialog = conversationContext.pop();//get last dialog
                    lastdialog?.BotResponse = [];
                    lastdialog?.responseToDisplay = [];
                    conversationContext.push(lastdialog!);
                }
                else
                {
                        conversationContext.push(elementToAdd); //add new dialog
                }
                
                //conversationContext.entities?.append(entity);
            }
        }
    }

    
    //step 1.determine dialog and method to call
    private func addDialogToConversation(_ topic:String,dialogToCall:String,entity:Entity?)
    {
        var dialog:Dialog;
        
        var hasentity:Bool = false//default false
        var iserrordialog = false;

        
        if entity == nil // if have no entity
        {
            hasentity = false;
        }
        else {hasentity = true;}
        
        
        switch topic
        {
        case "Greeting":
            dialog = GreetingDialog(dialogToCall: dialogToCall, patient: patient!);
        case "Patient":
            dialog = PatientDialog(dialogToCall: dialogToCall,patient:patient!);
        case "Appointment":
            dialog = AppointmentDialog(dialogToCall: dialogToCall, patient: patient!);
        case "Monitor":
            dialog = MonitoringDialog(dialogToCall: dialogToCall, patient: patient!);
        case "Medication":
            dialog = MedicationDialog(dialogToCall: dialogToCall, patient: patient!);
        case "None": //for passing entity
             dialog = Dialog(dialogToCall: dialogToCall)
        default: //error dialog
            iserrordialog = true;
            dialog = Dialog(dialogToCall: dialogToCall);//error dialog
        }
 
        
        checkContext(elementToAdd: dialog,entity: entity, hasEntity: hasentity,topic:topic,iserrordialog:iserrordialog);
    }
    
    
//
//    func defaultGreeting(patient:Patient) -> GreetingDialog
//    {
//        var gd = GreetingDialog(dialogToCall: "Info", patient: patient);
//        gd.getDialog();
//        return gd
//    }
    
    
}

extension DialogController:PromptAnsweredDelegate
{
    //ONCE USER HAS GIVEN ANSWER TO BOT, YES OR NO
    // WILL THEN THE DIALOG RESPONSE
    //AND PASS THE DIALOG TO UI
    func User(hasAnswered: String, dialog: Dialog) {
        //get prompt has and return to the ui
        
        //for medication
        let rdtype = type(of: dialog); //get type of recent dialog
        
        var med = MedicationDialog(dialogToCall: "", patient: patient!);
        let typeOfElement = type(of: med); // get type of dialog to add
        
        if rdtype == typeOfElement
        {
            
            let meddialog = dialog as! MedicationDialog;
            Botdelegate.receivedMedication(responseDialog: meddialog);
            return;
        }
        else
        {
            print(rdtype)
            print(typeOfElement)
        }
        
        Botdelegate.recievedPromptResponse(responseDialog: dialog);
    }
}

//GET DIALOG AFTER IT HAS DONE PROCESSING FROM DB AND PASS IN TO DELEGATE
extension DialogController:BotReplyDelegate
{
    func Nurse(response: Dialog) {

        Botdelegate.display(response: response);
        
        
        
    }
}


