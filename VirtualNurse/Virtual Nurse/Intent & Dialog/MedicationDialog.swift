//
//  MedicationDialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 30/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation
import UIKit;

class MedicationDialog:Dialog
{
    override var Intent: String { get { return "Medication" } }
    let imagePickerController = UIImagePickerController();
    
    
    init(dialogToCall:String,patient:Patient) {
        super.init(dialogToCall: dialogToCall)
        self.patient = patient;
    }
    
    override func getDialog() {
        switch self.dialog{
        case "Search":
            searchMedicine();
        default:
            self.responseToDisplay.append(error())
            self.BotResponse.append(error())
        }
    }
    
    func searchMedicine()
    {
        self.isPrompt = true;
        
        //prompt question
        let todisplay = "Do you mind taking a picture of your medicine ? I can help check for you.";
        let botReply = todisplay;
        //no need to call db here
        
        self.responseToDisplay.append(todisplay)
        self.BotResponse.append(botReply);
        
        self.brDelegate?.Nurse(response: self);
    }
    
    
    func askForSearchPermission()
    {
       // checkPermission();
        
    }
    
    func askForSearchYES()
    {
        
        //imagePickerController.sourceType = .photoLibrary // where the photo is taken from what source
        //imagePickerController.sourceType = .camera
        
        // present the system gallery
        
        //present(imagePickerController, animated: true, completion: nil)
        
        
//        // when a picture is selected, it will hid
//        scanBtn.isHidden = true
//
//        // when selected a photo, all elements are removed from the array
//        appendValues.removeAll()
//        predictValue.removeAll()
    }
    
    
   @objc override func promptHandler(sender: UIButton) {
    
    let text = sender.titleLabel?.text!
    print("Medication prompt handler tapped");
    
    if  text == "YES"{
        
        
       // paDelegate?.User(hasAnswered: text!, dialog: self);
        //PASS MESSAGE AND DELEGATE TO NOTIFY PATIENT
        paDelegate?.User(hasAnswered: text!, dialog: self)
        print("YES")
    }
    else
    {
        //PASS MESSAGE AND DELEGATE TO NOTIFY PATIENT
        paDelegate?.User(hasAnswered: text!, dialog: self)
        print("NO")
    }
    
    }
    
  
    
    
    
    

    
    
}
