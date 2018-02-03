//
//  MedicationDialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 30/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation
import UIKit;

class MedicationDialog:Dialog,UIImagePickerControllerDelegate
{
    override var Intent: String { get { return "Medication" } }
    
    
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
        
    }
    
    
   @objc override func promptHandler(sender: UIButton) {
    
    let text = sender.titleLabel?.text!
    print("Medication prompt handler tapped");
    
    if  text == "YES"{
        
        
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
    
    
    
//    private func checkPermission() {
//        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//
//        // switch case statement to know what results to be shown to user regarding the acceptance of authorization
//        switch photoAuthorizationStatus {
//        case .authorized: // Explicit user permission is required for photo library access, but the user has not yet granted or denied such permission.
//            print("Access is granted by user")
//        case .notDetermined:
//            //Requests the user’s permission, if needed, for accessing the Photos library.
//            PHPhotoLibrary.requestAuthorization({
//                (newStatus) in
//                print("status is \(newStatus)")
//                if newStatus ==  PHAuthorizationStatus.authorized {
//                    print("success")
//                }
//            })
//            print("It is not determined until now")
//        case .restricted: // app not authorized to access the photo library, and the user cannot grant such permission
//            print("User do not have access to photo album.")
//        case .denied: //The user has explicitly denied your app access to the photo library
//            print("User has denied the permission.")
//        }
//    }
    
    
}
