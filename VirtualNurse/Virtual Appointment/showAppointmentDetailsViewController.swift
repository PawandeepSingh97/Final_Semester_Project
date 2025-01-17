//
//  showAppointmentDetailsViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 4/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import Alamofire

class showAppointmentDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookedTime: UILabel!
    @IBOutlet weak var bookedDate: UILabel!
    @IBOutlet weak var bookedDoctor: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    var appoinmentItem : AppointmentModel?
    var doctorName: String = ""
    var doctorId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // styling for button
        let cornerRadius : CGFloat = 10.0
        confirmBtn.setTitle("Confirm", for: [])
        confirmBtn.setTitleColor(UIColor.white, for: [])
        confirmBtn.backgroundColor = UIColor.clear
        confirmBtn.layer.borderWidth = 2.0
        confirmBtn.layer.borderColor = UIColor.white.cgColor
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
        bookedTime.text = appoinmentItem!.time
        bookedDate.text = appoinmentItem!.date
        bookedDoctor.text = appoinmentItem!.doctorName
    }
    
   
    @IBAction func createAppointmentBtn(_ sender: Any) {
        
        let createParam: Parameters = [
            "nric": appoinmentItem!.nric,
            "doctorName": appoinmentItem!.doctorName,
            "Time": appoinmentItem!.time,
            "date": appoinmentItem!.date,
        ]
        
        let updateParam: Parameters = [
            "time": appoinmentItem!.time,
            "date": appoinmentItem!.date,
            ]
        
        
        
        
        PatientDataManager().getPatientByNRIC(appoinmentItem!.nric) { (patient) in
            print("nric \(self.appoinmentItem!.nric)")
            AppointmentDataManager().getDoctorIDByNameNric(patient.NRIC, patient.name, self.appoinmentItem!.doctorName, onComplete: { (Doctor) in

                self.doctorId = Doctor.id
                
                AppointmentDataManager().getDoctorTableByNricDocName(patient.NRIC,self.appoinmentItem!.doctorName, onComplete: { (Doctor) in

                    if(Doctor.date ==  ""){
                        //update the time and date on the doctor table
                        AppointmentDataManager().patchDoctorRecord(self.doctorId, updateParam, success: { (success) in
                            print(success)
                        }) { (error) in
                            print(error)
                        }
                    }else{
                        
                        let DoctorParam: Parameters = [
                            "time": self.appoinmentItem!.time,
                            "date": self.appoinmentItem!.date,
                            "doctorName": Doctor.doctorName,
                            "patientName": Doctor.patientNric,
                            "patientNric": Doctor.patientName,
                            "doctorSpeciality": Doctor.doctorSpeciality
                        ]
                        //create record on doctor table
                        AppointmentDataManager().postDoctorRecord(DoctorParam, success: { (success) in
                            print(success)
                        }, failure: { (error) in
                            print(error)
                        })
                    }
                })
                
               
                
                //Create appointment on the appointment table
                AppointmentDataManager().postAppointmentRecord(createParam, success: { (success) in
                    print(success)
                    DispatchQueue.main.async() {
                        let alertController = UIAlertController(title: "Confirmation", message:
                            "Your appointment have been Created", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                        self.performSegue(withIdentifier: "unwindToHome", sender: self)
  
                        }))
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    }
                }) { (error) in
                    print(error)
                }
            })
        }
 

    }

}
