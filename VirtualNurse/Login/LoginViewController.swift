//
//  LoginViewController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 20/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //FOR AUTHENTICATION
    struct KeychainConfiguration {
        static let serviceName = "VirtualNurse"
        static let accessGroup: String? = nil
    }
    let touchID = BiometricIDAuth()
    
    //MARK:Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        //REMOVE THIS 
        usernameTxtField.text = "S9738337E";
        passwordTxtField.text = "Test1234";
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap);
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        //Checks if user had ask for touchID
        let preferTouchID = UserDefaults.standard.bool(forKey: "hasTouchIDKey");
        if preferTouchID
        {
            let touchBool = touchID.canEvaluatePolicy();
            if touchBool { //if touch ID is available
                touchIDAuthentication();//ask for authentication
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:Action Handler
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //when login button clicked
    @IBAction func loginActionHandler(_ sender: Any)
    {
        if usernameTxtField.hasText && usernameTxtField.hasText//if field not empty
        {
            //check Login
            checkLogin(username: usernameTxtField.text!, password: passwordTxtField.text!);
            
           
            
        }
        else
        {
            showLoginFailedAlert();
        }
        

        
    }
    
    /*Check if is authenticated user*/
    func checkLogin(username:String,password:String)
    {
        let user = User(username,password);
        UserDataManager.getUser(user: user) { (isUser) in
            if isUser//if is user
            {
//                // get value of bool
//                let preferTouchID = UserDefaults.standard.bool(forKey: "hasTouchIDKey");
//                if !preferTouchID{//if user does not prefers toucID
//                    //ask first
//
//                            promptForTouchID();
//
//
//                };
                
                //set username value to a key
                UserDefaults.standard.setValue(username, forKey: "username");
                print(UserDefaults.standard.value(forKey: "username") as! String);
                //GET PATIENT DATA
                self.getPatientandDisplayDashboard(nric: username);
                
            }
            else if !isUser
            {
                DispatchQueue.main.async
                    {
                            self.showLoginFailedAlert();
                }
                
            }
        }
    }
    
    /*
        GET patient data and display dashboard
     */
    func getPatientandDisplayDashboard(nric:String)
    {
        PatientDataManager.getPatientBy(NRIC:nric, onComplete:{
            (patient) in
        print("\n \(patient.NRIC) \n \(patient.name) \n \(patient.dateOfBirth)");
        DispatchQueue.main.async
            {
               // ONCE INTEGRATED THEN CAN
              //  self.DisplayDashboard(patient:patient);
            }});

    }
    
    
    /**
     Authenticate User
     */
    func touchIDAuthentication()
    {
        touchID.authenticateUser() { [weak self] message in
            if let message = message {
                // if the completion is not nil show an alert
                let alertView = UIAlertController(title: "Error",
                                                  message: message,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Invalid.", style: .default)
                alertView.addAction(okAction)
                self?.present(alertView, animated: true)
                
            } else { // if touch ID authenticated
                // retrieve nric
                // and display dashboard
                //let nric = UserDefaults.standard.value(forKey: "username") as! String
                //TODO: 
               // self?.getPatientandDisplayDashboard(nric: nric);
            }
        }
    }
    
    /*
     show fail login alert
     */
    private func showLoginFailedAlert() {
        let alertView = UIAlertController(title: "Login Problem",
                                          message: "Wrong username or password.",
                                          preferredStyle:. alert)
        let okAction = UIAlertAction(title: "Try Again!", style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
    
    
    /*
     //MAY CHANGE
     DISPLAY DASHBOARD
     */
    func DisplayDashboard(patient:Patient) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeDashboard", bundle: nil)
        let Dashboard = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeDashboardViewController;
        //present method must be called before setting contents
        self.present(Dashboard, animated: true, completion: nil);
        //Dashboard.patient = patient;
        
    }
    
    
    /*
        Prompt user for touch ID
     */
    func promptForTouchID()
    {
        let promptForTouchID = UIAlertController(title: "Touch ID", message: "Would you like to use Touch ID for the next time you login ?", preferredStyle: UIAlertControllerStyle.alert)
        
        promptForTouchID.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //if user agrees to touch ID use
            //set true
            UserDefaults.standard.set(true, forKey: "hasTouchIDKey");
            
        }))
        
        promptForTouchID.addAction(UIAlertAction(title: "Next Time", style: .cancel, handler: { (action: UIAlertAction!) in
            //if user DOES NOT AGREE to touch ID use
            //set false
            UserDefaults.standard.set(false, forKey: "hasTouchIDKey");
        }))
        
        present(promptForTouchID, animated: true, completion: nil)
    }

    

}
