//
//  showUpdateAppointmentDetailsViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 7/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import Alamofire

class showUpdateAppointmentDetailsViewController: UIViewController {


    @IBOutlet weak var updateBookedDoctor: UILabel!
    @IBOutlet weak var updateBookedDate: UILabel!
    @IBOutlet weak var updatebookedTime: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    var appoinmentUpdateItem : AppointmentModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cornerRadius : CGFloat = 10.0
        confirmBtn.setTitle("Confirmed", for: [])
        confirmBtn.setTitleColor(UIColor.black, for: [])
        confirmBtn.backgroundColor = UIColor.clear
        confirmBtn.layer.borderWidth = 1.0
        confirmBtn.layer.borderColor = UIColor.black.cgColor
        confirmBtn.layer.cornerRadius = cornerRadius
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatebookedTime.text = appoinmentUpdateItem!.time
        updateBookedDate.text = appoinmentUpdateItem!.date
        updateBookedDoctor.text = appoinmentUpdateItem!.doctorName
    }
    
    @IBAction func updateAppointmentBtn(_ sender: Any) {
        let updateParam: Parameters = [
            "nric": appoinmentUpdateItem!.nric,
            "doctorName": appoinmentUpdateItem!.doctorName,
            "Time": appoinmentUpdateItem!.time,
            "date": appoinmentUpdateItem!.date,
            ]
        print("hi2\(updateParam)")
        
        let updateDoctorParams: Parameters = [
            "time": appoinmentUpdateItem!.time,
            "date": appoinmentUpdateItem!.date,
            ]
        
        
        AppointmentDataManager().getDoctorTableByNricName(appoinmentUpdateItem!.nric, appoinmentUpdateItem!.doctorName) { (Doctor) in
            AppointmentDataManager().patchDoctorRecord(Doctor.id, updateDoctorParams, success: { (success) in
                print(success)
            }, failure: { (error) in
                print(error)
            })
        }
        
        AppointmentDataManager().patchAppointmentRecord(appoinmentUpdateItem!.id, updateParam, success: { (success) in

          DispatchQueue.main.async() {
                let alertController = UIAlertController(title: "Confirmation", message:
                    "Your appointment have been updated", preferredStyle: UIAlertControllerStyle.alert)
                  alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                     self.performSegue(withIdentifier: "unwindToVC1", sender: self)
                }))
                self.present(alertController, animated: true, completion: nil)
            

            }
            print(success)
        }) { (error) in
            print(error)
        }
    }
    

 

}
