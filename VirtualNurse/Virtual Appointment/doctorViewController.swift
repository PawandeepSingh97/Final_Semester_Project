//
//  doctorViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 23/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class doctorViewController: UIViewController {

    @IBOutlet weak var doctortxt: UITextField!

    var selectedDoctor: String?
    var doctorList: Array = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorName()
        createDoctorPicker()
        createToolBar()
        rightButtonItem()
        // Do any additional setup after loading the view.

        
    }
    
    func rightButtonItem(){
        let rightButtonItem = UIBarButtonItem.init(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(menuNextButton(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func doctorName(){
        //Set patient NRIC
        let patientNric:String = "S9822477G"
        
        AppointmentDataManager().getDoctorTableByNric(patientNric) { (Doctor) in
            self.doctorList.append(Doctor.doctorName)
            print("Doctors\(Doctor.doctorName)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createDoctorPicker() {
        let doctorPicker = UIPickerView()
        doctorPicker.delegate = self
        doctortxt.inputView = doctorPicker
        
        //customization
        doctorPicker.backgroundColor = .black
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
    
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //customization
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title:"Done", style: .plain, target: self, action: #selector(doctorViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        doctortxt.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //pass selected doctor to next page
    @objc func menuNextButton(sender: UIBarButtonItem) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "CreateAppointmentViewController") as! CreateAppointmentViewController
        myVC.doctorName = doctortxt.text!
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
}

extension doctorViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let uniqueStrings = uniqueElementsFrom(array:self.doctorList)
        return uniqueStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let uniqueStrings = uniqueElementsFrom(array:self.doctorList)
        return uniqueStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let uniqueStrings = uniqueElementsFrom(array:self.doctorList)
        selectedDoctor = uniqueStrings[row]
        doctortxt.text = selectedDoctor
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let uniqueStrings = uniqueElementsFrom(array:self.doctorList)
        var label: UILabel
        
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 17)
        label.text = uniqueStrings[row]
        
        return label
    }
}
