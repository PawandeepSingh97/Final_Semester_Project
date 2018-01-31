//
//  ViewController.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 1/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import UIKit



class MedicineViewController: UIViewController,  UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    
    // Codes that connect to the storyboard
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var scanMedsBtn: UIButton!
    @IBOutlet weak var medicineImages: UIImageView!
    @IBOutlet weak var medicineSearchTB: UITextField!
    
    
    var medicineName : String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Makes the button to have rounded edges
        makeRoundedButton()
    }
    
    func makeRoundedButton(){
        
        searchBtn.layer.cornerRadius = searchBtn.frame.height / 2
        scanMedsBtn.layer.cornerRadius = scanMedsBtn.frame.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "destination") {
        
        let secondViewController = segue.destination as? medicineDetailController
        
        
        secondViewController!.medNames = medicineSearchTB.text!
  
       
       
             }
        }
        
    }



