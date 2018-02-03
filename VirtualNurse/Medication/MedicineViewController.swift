//
//  ViewController.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 1/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import UIKit
//import TextFieldEffects


class MedicineViewController: UIViewController,  UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    var recievedArray : [String] = [String]()
    
    
  //  @IBOutlet weak var medicineSearchJB: JiroTextField!
    // Codes that connect to the storyboard
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var scanMedsBtn: UIButton!
  //  @IBOutlet weak var medicineImages: UIImageView!
    @IBOutlet weak var medicineSearchTB: UITextField!
    
    
    var medicineName : String = "";
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Makes the button to have rounded edges
        makeRoundedButton()
       // searchBtn.backgroundColor = UIColor.blue  3F51B5
    //    scanMedsBtn.backgroundColor = UIColor.init(hex: 0x3F51B5)
    //    searchBtn.backgroundColor = UIColor.init(hex: 0x3F51B5)
        
    //    validationTF()
        
        self.medicineSearchTB.delegate = self
        self.medicineSearchTB.returnKeyType = .done
        
        

        
    }
    
    func textFieldShouldReturn(_ medicineSearchTB: UITextField) -> Bool
    {
        medicineSearchTB.resignFirstResponder()
        return true
    }
  

    
    func makeRoundedButton(){
        searchBtn.layer.cornerRadius = 10.0
        //scanMedsBtn.layer.cornerRadius = 10.0
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
        var set = Set<T>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }

    @IBAction func searchAction(_ sender: Any) {
        
        if (self.medicineSearchTB.text! == "") {
            
            print("No entry has been created!")
            
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
            
            print("No entry has been created!")
            
                                    if (segue.identifier == "destination") {
                                        
                                        validationTF();
                                        
                                        let secondViewController = segue.destination as? medicineDetailController;
                                        secondViewController!.medNames = self.medicineSearchTB.text!
            }
}
    
    
    func validationTF(){
        
        if (self.medicineSearchTB.text!.isEmpty) {
            
            print("Text field is empty")
            let alertView = UIAlertController(title: "Enter Medicine Name to Search",
                                              message: "Medicine Name is Empty",
                                              preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true)
      
            
        }
        
        else {
     
        }
        
        
    }
}
