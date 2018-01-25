//
//  ScanVC.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 2/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import UIKit
import PhotosUI // for photo library

class ScanVC: UIViewController,  UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    
    
    // connects to the storyboard
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var predictedName: UILabel!
    @IBOutlet weak var predictedValue: UILabel!
    @IBOutlet weak var moreInfoBtn: UIButton!
    
    // declare variables & array & objects
    var estimatedValues : [Float] = []
    var appendValues : [String] = []
    var predictValue : [String] = []
    var firstValues : Float = 0
    var medicineList : [MedicineModel] = []
    
    
    // connects to the storyboard
    @IBOutlet weak var resultIV: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // calls class which handles custom vision service
    var service = CustomVisionService()
    
    func buttonAction(sender:UIButton)
    {
      //  let hustler = medicineVC()
      //  hustler.medicineTitleValue = predictedName.text!
    }

    //  self.moreInfoBtn.addTarget(self, action: "buttonAction:", for: UIControlEvents.touchUpInside)

    
     override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //makes button to have rounded edges
        scanBtn.layer.cornerRadius = scanBtn.frame.height / 2
        
        // ask users permission whenever user wants to choose medicine image from library
        checkPermission()
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // give disclaimer to users
        startAlert()
    }
    
    
    // this function gets
    func getMedicineDetails() {
        
        MedicineDataManager().getMedicineRecordsByName(self.predictedName.text!) { (Medicine)  in
            
            let retrievedName = Medicine.medicineName
            
            print("Retrieved Medicine Name \(retrievedName)")
            
          

        }
        
    }
    
    // this methods handles the alert function
    
    func startAlert() {
        
        // declare an alert message
        let alertController = UIAlertController(title: "Disclaimer", message: "We hereby declare that the predications for identifying medications are not fully accurate. Use this at your own risk. Any enquires, contact Pawandeep", preferredStyle: UIAlertControllerStyle.alert)

        // sets what button to be included in the alert message
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        //attaches button to alert message
        alertController.addAction(okAction)
        
        // presents alert message modally
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // this function check users has granted permission for photo library
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        // switch case statement to know what results to be shown to user regarding the acceptance of authorization
        switch photoAuthorizationStatus {
        case .authorized: // Explicit user permission is required for photo library access, but the user has not yet granted or denied such permission.
            print("Access is granted by user")
        case .notDetermined:
            //Requests the user’s permission, if needed, for accessing the Photos library.
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted: // app not authorized to access the photo library, and the user cannot grant such permission
            print("User do not have access to photo album.")
        case .denied: //The user has explicitly denied your app access to the photo library
            print("User has denied the permission.")
        }
    }
    
    // function for button for selecting photos
  
    @IBAction func selectButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary // where the photo is taken from what source
        
        imagePickerController.delegate = self
        
        // present the system gallery
        present(imagePickerController, animated: true, completion: nil)
        
        
        // when a picture is selected, it will hid
        scanBtn.isHidden = true
        
        // when selected a photo, all elements are removed from the array 
        appendValues.removeAll()
        predictValue.removeAll()
       
    }
    
    
    //function to add lines
    func addLines() {
        
        let lineView = UIView(frame: CGRect(x: 0, y: 100, width: 320, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView)
    }
    
  
    // what happen if user dismiss image picker operation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // image picker is being dismiss
        dismiss(animated: true, completion: nil)
    }
 //  moreInfoBtn.addTarget(self, action: "buttonAction:", for: UIControlEvents.touchUpInside)

    // function for image picker once user is done selecting the images in the photo library
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Reloaded")
       // var highestGuess : [Float] = []

        
        guard  let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
            
            fatalError("Expected an image, but was provided \(info)")
        }
        
        resultIV.image = selectedImage // displays selected image to image view
        dismiss(animated: true, completion: nil) // dismiss the image picker
        
        // activity indicator starts animating
        activityIndicator.startAnimating()
        LoadingIndicatorView.show("Loading")
        
        // this variable is the image in JPEG format with compression quality
        let imageData = UIImageJPEGRepresentation(selectedImage, 0.8)!
        
        
        // gets prediction ,tags from CustomVision A.I.
        service.predict(image: imageData, completion: { (result: CustomVisionResult?, error: Error?) in
            DispatchQueue.main.async {
                // Custom Vision A.I. should be done transmiting data
                
                
                // index for the first element, which is defined as 0
                //var index123 : Int = 0

                // once data is back, activity indicator will stop animating
                self.activityIndicator.stopAnimating()
                // scan button will be shown
                self.scanBtn.isHidden = false
                if
                    let error = error {
                    self.predictedName.text = error.localizedDescription
                } else if
                    
                    
                    // displayes results from Custom Vision A.I.
                    let result = result {
                    
                    
                    // object which contains the predictions for every medication in the custom vision
                    for taggers in result.Predictions {

                    // declares varialbe
                    var highestGuess : [Float] = [] // array of prediction of all medications
                    var guessByAI : Float
                    let prediction = taggers // CustomVision variable
                    
                        
                        /// rounds up probability and sets it on probability label
                    let probabilityLabel = String(format: "%.1f", prediction.Probability * 100)
                        
                        // contains elemnts of probability in an understood way of all medications
                    self.estimatedValues.append(prediction.Probability * 100)
                        
                        
                        // contrains porability of a medication
                      guessByAI = prediction.Probability * 100
                        

                            self.appendValues.append(probabilityLabel)
                            highestGuess.append(guessByAI)
                            self.predictValue.append(prediction.Tag)
                   
                        
                        
                        print("\(probabilityLabel) \(prediction.Tag)")
                        

                    
                    }
                    
                    
                }
                

                self.predictedName.text = self.predictValue[0]
                self.predictedValue.text = "\(self.appendValues[0])% sure that it is \(self.predictValue[0])"
                
                
                print("The first place goes to \(self.predictValue[0]) & \(self.appendValues[0])%")
                
                self.firstValues = NSString(string : self.appendValues[0]).floatValue
                
                print("THe first value it is \(self.firstValues)")

                self.checkProbable(valued: self.firstValues)
                
                self.getMedicineDetails()
                
                LoadingIndicatorView.hide()

            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // this function is to check whether the prediction is reliable or not for user
    func checkProbable(valued : Float) {
        
        // if the prediciton of the medication is less than 30

        if valued < 30 {
            
            predictedValue.isHidden = true
            predictedName.isHidden = true
            
        }
        
        else {
            
            moreInfoBtn.isHidden = false
            moreInfoBtn.isEnabled = true
            
        }

    }
    


    


    
}
