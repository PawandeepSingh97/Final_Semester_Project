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
    private var service = CustomVisionService();
    
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
        
        var localecode = UserDefaults.standard.value(forKey: "language") as! String;
        
        //prompt question
        let todisplay = "Do you mind taking a picture of your medicine ? I can help check for you.";
        let botReply = todisplay;
        
        self.MT.Translate(from: "en", to: localecode, text: todisplay, onComplete: { (convertedText) in
            self.responseToDisplay.append(convertedText)
            self.BotResponse.append(convertedText)
            self.brDelegate?.Nurse(response: self);
        })
        
        
        //no need to call db here
        
        //self.responseToDisplay.append(todisplay)
        //self.BotResponse.append(botReply);
        
        
    }
    
    
    func askForSearch()
    {
       // checkPermission();
        
    
        //self.isPrompt = true;
        
    }
    
    func askForSearchYES()
    {
        
    }
    
    func askForSearchNo()
    {
        let todisplay = "Sure thing. Let me know if you are not sure what medicine you are holding.";
        let botReply = todisplay;
        //no need to call db here
        
        self.responseToDisplay.append(todisplay)
        self.BotResponse.append(botReply);
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
        askForSearchNo();
        //PASS MESSAGE AND DELEGATE TO NOTIFY PATIENT
        paDelegate?.User(hasAnswered: text!, dialog: self)
        print("NO")
    }
    
    }
    
    func searchMedicine(image:UIImage,onComplete:((_ md : MedicationDialog) -> Void)?) {
        // this variable is the image in JPEG format with compression quality
         var localecode = UserDefaults.standard.value(forKey: "language") as! String;
        let imageData = UIImageJPEGRepresentation(image, 0.8)!;
        service.predict(image: imageData) { (result, error) in
         
            
            if let error = error {
                //error will be shown here!
                
                let toDisplay = "It doesn't seem to be a medicine. Please try again if you are sure.";
                let botReply = toDisplay;
                
                self.MT.Translate(from: "en", to: localecode, text: toDisplay, onComplete: { (convertedText) in
                    self.responseToDisplay.append(convertedText)
                    self.BotResponse.append(convertedText)
                    self.brDelegate?.Nurse(response: self);
                    
                })
                
            }
            else if let result = result {// displayes results from Custom Vision A.I.
                // object which contains the predictions for every medication in the custom vision
                for taggers in result.Predictions {
                    
                    // declares varialbe
                    var highestGuess : [Float] = [] // array of prediction of all medications
                    var guessByAI : Float
                    let prediction = taggers // CustomVision variable
                    
                    
                    /// rounds up probability and sets it on probability label
                    let probabilityLabel = String(format: "%.1f", prediction.Probability * 100)
                    
                    // contains elemnts of probability in an understood way of all medications
                    //self.estimatedValues.append(prediction.Probability * 100)
                    
                    
                    // contrains porability of a medication
                    guessByAI = prediction.Probability * 100
                    
                    //self.appendValues.append(probabilityLabel)
                    highestGuess.append(guessByAI)
                    //self.predictValue.append(prediction.Tag)
                    
                    print("\(probabilityLabel) \(prediction.Tag)");
                    
                    
                    MedicineDataManager().getMedicineRecordsByName(prediction.Tag) { (Medicine)  in
                        
                        
                    
                        let toDisplay = "This medicine might be called \(Medicine.medicineName). \(Medicine.medicineDesc).\nRecommended to \(Medicine.medicineDosage).To consume \(Medicine.consumptionInstructions)";
                        let botReply = toDisplay;
                        
                        
                        self.MT.Translate(from: "en", to: localecode, text: toDisplay, onComplete: { (convertedText) in
                            self.responseToDisplay.append(convertedText)
                            self.BotResponse.append(convertedText)
                            onComplete?(self);
                            
                        })
                        
                      //  self.responseToDisplay.append(toDisplay)
//                        self.BotResponse.append(botReply)
                        //self.paDelegate?.User(hasAnswered: "medicineSearch", dialog: self);
                        //self.brDelegate?.Nurse(response: self);
                        
                        
                    }
                    break;
                }
            }
        }
        
        
    }
    

    
    
    // this function is to check whether the prediction is reliable or not for user
    private func checkProbable(valued : Float) {
        
        // if the prediciton of the medication is less than 30
        
        if valued < 30 {
            //var nama = predictedName.text!
            //  testing
            //print("Nama Sama Sayang ? Tutkup Di Punya Satu ? : \(nama)")
            print("not probable")
            let alert = UIAlertController(title: "Please try again", message: "Try capturing the pill in a well - lit area & make sure it is a Diabetic medication. Thank You!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.default, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
        else {
            //nama = predictedName.text!
            //testing
            print("isprobable")
            //print("Nama Sama Sayang ? Tutkup Di Punya Dua ? : \(nama)")
        }
    }
 
}

