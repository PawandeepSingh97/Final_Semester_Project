//
//  DialogController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 4/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

protocol BotResponseDelegate:class {
    func BotResponse(get:Dialog) -> String;
    
}

//Dialog Controller will interact with viewController,dialog and LUIS endpoint
class DialogController: NSObject {
    
    
    
    var patient:Patient?;
    var delegate:BotResponseDelegate!;
    
    //STORES CONVERSATION AND ITS ENTITIES
    struct ConversationStack {
        fileprivate var converasationContext: [Dialog] = [];
        
        
        //PUSH DIALOG IN array
        mutating func push(_ element:Dialog)
        {
            converasationContext.append(element);
        }
        
        //Pop Dialog
        mutating func pop() -> Dialog? {
            
            return converasationContext.popLast()
        }
        
        //Peek Dialog
        func peek() -> Dialog? {
            return converasationContext.last
        }
        
        //REMOVE ALL ELEMENTS IN STACK
      mutating  func removeAll()
        {
            converasationContext.removeAll();
            
        }
    
        func count() -> Int
        {
           return converasationContext.count;
        }
        
    }
    
     var conversationContext = ConversationStack();
    
    //TALK TO LUIS
     func query(text:String,onComplete:((_:String) -> Void)?)
    {
        LUISDataManager.queryLUIS(query: text) { (intent) in
            //Once determine INTENT FROM LUIS
            intent.processIntent();//will determine topic and dialog
            let topic = intent.topic;
            let dialog = intent.dialog;
           // let entities = intent.entities;
            
            self.addDialogToConversation(topic!, methodToCall: dialog!);
            let response = self.dialogToRespond();
           // var response = self.BotResponse(topic:topic!, dialogtocall: dialog!);
            
            onComplete?(response);
        }
    }
    
    
    
    //This will display string to UI
    private func dialogToRespond() -> String
    {
        //delegate?.BotResponse(get: conversationContext.peek()!);
        //conversationContext
        return conversationContext.peek()!.getDialog();
    }
    
    //check stack maintains conversation
    //step1.1:ensure that conversation is within the same topic
    //else remove all the entire elements in stack
    private func checkContext(elementToAdd:Dialog)
    {
     //CHECK IF LAST ELEMENT MATCHES TYPE OF ELEMENT THAT IS ABOUT TO BE ADDED
        //IF THE TYPE IS SAME,ADD TO STACK
        // IF TYPE IS DIFFERENT, REMOVE ALL ELEMENTS IN STACK AND ADD AGAIN
        
        if conversationContext.count() == 0
        {
            conversationContext.push(elementToAdd);
        }
        else
        {
            let recentdialog = conversationContext.peek()!;
            let rdtype = type(of: recentdialog);
            
            let typeOfElement = type(of: elementToAdd);
            
            if rdtype == typeOfElement
            {
                conversationContext.push(elementToAdd);
                print(" \(typeOfElement)");
            }
            else
            {
                conversationContext.removeAll();
                conversationContext.push(elementToAdd);
            }
        }
        
        
    }
    
    
    //step 1.determine dialog and method to call
    private func addDialogToConversation(_ topic:String,methodToCall:String)
    {
        var dialog:Dialog;
        
        //for testing
        if patient == nil
        {
            dialog = Dialog(methodToCall: methodToCall);//error dialog
            checkContext(elementToAdd: dialog);
            return;
        }
        
        switch topic{
        case "Patient"://patient topic
            dialog = PatientDialog(methodToCall: methodToCall,patient:patient!);
            //conversationContext.push(dialog);
        case "Appointment"://appoinment topic
            dialog = AppointmentDialog(methodToCall: methodToCall, patient: patient!);
           // conversationContext.push(dialog);
            
        default:
            dialog = Dialog(methodToCall: methodToCall);//error dialog
        }
        
        checkContext(elementToAdd: dialog);
    }
    
    
    //SWITCH CASE
    //must also pass entites
//    private func BotResponse(topic:String,dialogtocall:String) -> String
//    {
//        switch topic {
//        case "Patient":
//            //call patient dialog
//            var pd = PatientDialog(methodToCall:dialogtocall,patient:patient!);
//            return pd.getDialog();
//        default:
//            //error handle dialog
//            print("topic fail")
//            return "error";
//        }
//    }
    
}



