//
//  ViewAppointmentViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 30/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import Alamofire

class ViewAppointmentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
     var appointmentList : [AppointmentModel] = []
     var appointmentAvailableList: [DoctorModel] = []
     var appointmentCheckedList: [DoctorModel] = []
//     var DoctorName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.rightBarButtonItem = editButtonItem

    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.appointmentList.removeAll()
            self.appointment()
            self.appointmentChecked()
//            self.getAppointmentChecked()
        }
    }
    
    func getAppointmentChecked(_ docName:String) {
        
        let patientNric:String = "S9822477G"
//        let docName: String = "Dr David Cahill"
        print("HIDoctorNAME \(docName)")
        AppointmentDataManager().getDoctorTableByNricName(patientNric, docName) { (Doctor) in
            print("CHECHED DOCTOR \(Doctor)")
             self.appointmentCheckedList.append(DoctorModel(Doctor.id, Doctor.patientName, Doctor.patientNric, Doctor.doctorName, Doctor.date, Doctor.time, Doctor.doctorSpeciality))
        }

    }
    
    func currentTime() -> String {
        
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let dateAsString = "\(hour):\(minutes)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let dateChanged = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: dateChanged!)
        
        return "\(Date12)"
    }
    
    func convertTime( _ Time:String) -> String{
        let dateAsString = Time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: dateAsString)
        
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from: date!)
        
        return date24
    }
    
    func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let str =  formatter.string(from: date)
        return str
    }

    
    func convertDate(_ Date:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let str = formatter.date(from: Date)!
        return str
    }
    
    func appointmentChecked(){
        let patientNric:String = "S9822477G"
    

        //Call the getAppointmentByNRIC in AppointmentDataManager to retrieve appointment records
        AppointmentDataManager().getAppointmentByNRIC(patientNric) { (Appointment) in
            let dateStr = Appointment.time
            let dateStrOfArray = dateStr.components(separatedBy: "-")
            var timeList: Array = [String] ()

            let appointmentDate = self.convertDate(Appointment.date)
            let currentDate = self.convertDate(self.getCurrentDate())
            
            if appointmentDate <= currentDate {

                    for DateStr in dateStrOfArray {

                        timeList.append(DateStr)
                        let time = self.convertTime(timeList[0])
                        let currentTime = self.convertTime(self.currentTime())

                        if time <= currentTime{

                            
                            // Delete from doctor table
                            AppointmentDataManager().getDoctorTableByAll(Appointment.nric, Appointment.doctorName, Appointment.time, Appointment.date, onComplete: { (Doctor) in
                                print("appcheck \(self.appointmentCheckedList.count)")
                                self.getAppointmentChecked(Doctor.doctorName)
                                if self.appointmentCheckedList.count == 1{
                                    let updateDoctorParams: Parameters = [
                                        "time": "",
                                        "date": "",
                                        ]

                                    AppointmentDataManager().patchDoctorRecord(Doctor.id, updateDoctorParams, success: { (success) in
                                        print(success)
                                    }, failure: { (error) in
                                        print(error)
                                    })
                                } else{
                                
                                    AppointmentDataManager().DeleteDoctorRecord(Doctor.id, success: { (success) in
                                        print(success)
                                    }, failure: { (error) in
                                        print(error)
                                    })
                             }
                            })
                            
                            //delete from appointment table
                            AppointmentDataManager().DeleteAppointmentRecord(Appointment.id, success: { (success) in
                                DispatchQueue.main.async {
                                    self.appointmentList.removeAll()
                                    self.appointment()
                                    self.collectionView.reloadData()
                                }
                                print(success)
                            }, failure: { (error) in
                                print(error)
                            })
                    }
                }
            }
        }
    }

    
 
    
    func appointment(){
        let patientNric:String = "S9822477G"
        
        //Call the getAppointmentByNRIC in AppointmentDataManager to retrieve appointment records
        AppointmentDataManager().getAppointmentByNRIC(patientNric) { (Appointment) in
            //Retrieved results from Database
            
            print("appointments\(Appointment)")
            self.appointmentList.append(AppointmentModel(Appointment.id,Appointment.nric,Appointment.doctorName,Appointment.date,Appointment.time))
            
            self.collectionView.reloadData()

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPatientNric ()->String{
        let nric = ""
        return nric
    }

    //collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return appointmentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ViewAppointmentCollectionViewCell
        cell.doctorName.text = appointmentList[indexPath.row].doctorName
        cell.time.text = appointmentList[indexPath.row].time
        cell.date.text = appointmentList[indexPath.row].date
        print("id \(appointmentList[indexPath.row].id)")

        cell.delegate = self
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item \(indexPath)")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if let indexPaths = collectionView?.indexPathsForVisibleItems{
            for indexPath in indexPaths{
                if let cell = collectionView?.cellForItem(at: indexPath) as? ViewAppointmentCollectionViewCell {
                    cell.isEditing = editing
                }
            }
        }
    }
   
    
    //pass appointment information to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "UpdateAppointmentDetails") {
            let updateViewController = segue.destination as! UpdateAppointmentViewController
            let cell = sender as! UICollectionViewCell
            if let indexPath = self.collectionView?.indexPath(for: cell){
                
                let patientAppointmentDate = "\(self.appointmentList[indexPath.row].date)"
                let patientAppointmentTime = "\(self.appointmentList[indexPath.row].time)"
                let patientAppointmentNRIC = "\(self.appointmentList[indexPath.row].nric)"
                let patientAppointmentDoctorName = "\(self.appointmentList[indexPath.row].doctorName)"
                let patientAppointmentID = "\(self.appointmentList[indexPath.row].id)"
                
                if(indexPath != nil) {
                    
                    let appointment = AppointmentModel(
                        patientAppointmentID,
                        patientAppointmentNRIC,
                        patientAppointmentDoctorName,
                        patientAppointmentDate,
                        patientAppointmentTime
                    )
                    
                    updateViewController.appoinmentItem = appointment
                    
                }
        
            }

        }
    }

}


// delete button for collection view

extension ViewAppointmentViewController: ViewAppointmentCollectionViewCellDelegate{

    func delete(cell: ViewAppointmentCollectionViewCell ){
        let alert = UIAlertController(title: "Alert", message: "Do you want to cancel appointment", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
    
            if let indexPath = self.collectionView?.indexPath(for: cell){
                
                let patientAppointmentDate = "\(self.appointmentList[indexPath.row].date)"
                let patientAppointmentTime = "\(self.appointmentList[indexPath.row].time)"
                AppointmentDataManager().getAppointmentByDateTime(patientAppointmentDate, patientAppointmentTime, onComplete: { (appointment) in
                    
                    let patientAppointmentId = appointment.id
                    let patientNric = appointment.nric
                    let doctorName = appointment.doctorName
                    
                    AppointmentDataManager().getDoctorTableByAll(patientNric, doctorName, patientAppointmentTime, patientAppointmentDate, onComplete: { (Doctor) in

                        
                        self.appointmentAvailableList.append(DoctorModel(Doctor.id, Doctor.patientName, Doctor.patientNric, Doctor.doctorName, Doctor.date, Doctor.time, Doctor.doctorSpeciality))

                        if self.appointmentAvailableList.count == 1{
                            print("number\(self.appointmentAvailableList.count)")
                            let updateDoctorParams: Parameters = [
                                "time": "",
                                "date": "",
                                ]
                            AppointmentDataManager().patchDoctorRecord(Doctor.id, updateDoctorParams, success: { (success) in
                                print(success)
                            }, failure: { (error) in
                                print(error)
                            })
                            
                        }else{
                            AppointmentDataManager().DeleteDoctorRecord(Doctor.id, success: { (success) in
                                print(success)
                            }, failure: { (error) in
                                print(error)
                            })
                            
                        }
                        
                    })
                    

                    //delete from appointment table
                    AppointmentDataManager().DeleteAppointmentRecord(patientAppointmentId, success: { (success) in
                        DispatchQueue.main.async {
                            self.appointmentList.removeAll()
                            self.appointment()
                            self.collectionView.reloadData()
                        }
                        print(success)
                    }, failure: { (error) in
                        print(error)
                    })
                 
                })
                
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
