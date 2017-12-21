//
//  LoginViewController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 20/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //GITHUB WORKS
    
    //MARK:Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var appLogo: UIImageView!
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    var hasLoggedIn = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:Action Handler
    
    //when login button clicked
    @IBAction func loginActionHandler(_ sender: Any) {
        let username = usernameTxtField.text!;
        let password = passwordTxtField.text!;
        
        if !( username.isEmpty && password.isEmpty)
        {
            print(username);
            print(password);
            
            //TODO : Validate if user exits
            let user = User(username,password);
            UserDataManager.getUser(user: user, onComplete: { (isUser) in
                if (isUser) //if is user
                {
                    //HERE WILL GET PATIENT DATA
                    // AND PASS TO DASHBOARD
                    PatientDataManager.getPatientBy(NRIC: user.username, onComplete:
                        {
                            (patient) in
                            print("\n \(patient.NRIC) \n \(patient.name) \n \(patient.dateOfBirth)");
                    });
                    
                    
                    DispatchQueue.main.async {
                        self.DisplayDashboard()
                    }
                }
                else //IF NOT USER,tell user to try again
                {
                    
                }
            })
        }
        
    }
    
    
    func DisplayDashboard() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeDashboard", bundle: nil)
        let Dashboard = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeDashboardViewController;
        //present method must be called before setting contents
        self.present(Dashboard, animated: true, completion: nil)
        //dashboard.passdata() //or something
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
//        if segue.identifier == "LoginSegue"
//        {
//            print("hello world");
//        }
        
    }
    

}
