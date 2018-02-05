//
//  ChatSettingsViewController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 25/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import Speech;

class ChatSettingsViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {
    
    

    
    private let languages = ["English","Chinese","Malay","Tamil"];
    
    private let languageCode = ["en","zh-CN","",""];
    
    @IBOutlet weak var languagePickerField: UITextField!
    @IBOutlet weak var allowSpeakingSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // languagePickerField.delegate = self;
        let pickerView = UIPickerView();
        pickerView.delegate = self;
        languagePickerField.inputView = pickerView;
        
        
        let localecode = UserDefaults.standard.value(forKey: "language") as? String;
        if localecode == nil{
            languagePickerField.text = languages[0]
        }
        else {
            
            for lng in languages
            {
                if lng == "en"{
                    languagePickerField.text = languages[0];
                }
                else if lng == "zh-CN"
                {
                    languagePickerField.text = languages[1];
                }
            }
        }
        
        
        
        //UserDefaults.standard.setValue(username, forKey: "language");
        //print(UserDefaults.standard.value(forKey: "language") as! String);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //self.view.endEditing(true)
        return languages[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languagePickerField.endEditing(true)
        languagePickerField.text = languages[row];
        
        UserDefaults.standard.setValue(languageCode[row], forKey: "language");
        changeSpeechLanguage();
    }
    
    func changeSpeechLanguage()
    {
        let chatview = navigationController?.viewControllers[0] as! ChatViewController;
        var localecode = UserDefaults.standard.value(forKey: "language") as? String;
        if localecode == nil
        {
            localecode = "en";
            chatview.changeSpeechLocale(code: localecode!)
        }else
        {
                chatview.changeSpeechLocale(code: localecode!)
        }
        
        
       
        //let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en"))
        
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//            //self.languagePickerField.inputView?.isHidden = false;
//             //languagePickerField.endEditing(true)
//    }

}
