//
//  ChatViewController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 26/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

/*
 TODO FOR VIRTUAL NURSE
 : CHANGE STYLE OF CHAT BUBBLE -- DONE
 : ADD BUTTON ON CHAT BUBBLE -- NOT YET
 : CHANGE ENTIRE LAYOUT OF MIC AND BG -- NOT YET
 : LINK WITH LUIS - DONE
 : ABLE TO LINK LUIS INTENT WITH RESPECTIVE DIALOG - DONE
 : PLACE DIALOG ON CHAT BUBBLE - DONE
 : ABLE TO GO TO DIFFERENT PAGES BASED ON INTENT -- IN PROGRESS
 : HAVE SETTINGS PAGE - CHANGE/INVERT COLOR, CHANGE PREFFEREND LANGUAGE, ALLOW/DISABLE BOT TO SPEAK, SET DEFAULT TO MIC/KEYBOARD -- IN PROGRESS
 :
 : SET UP UTTERANCES/INTENTS
----------------------------------------------------------------
 ASK
 : NEED TO CREATE A DIALOG TABLE : SAVE CONVERSATIONS ?
 :
----------------------------------------------------------------
 TODO FOR LOGIN
 : CHANGE STYLE
 : ALLOW FINGER AUHTHENTICATION
 : ABLE TO DETERMINE IF USER HAS LOGGED IN BEFORE - USING THE SWIFT KEY CHAIN
 
 **/

import UIKit;
import MessageKit;
import Speech

class ChatViewController: MessagesViewController {

    var patient:Patient?;
    
    var dialogController:DialogController?;
    
    //Store all messages
    var messages:[MockMessage] = [];
    
    //currentUser is the patient using device
    var currentUser = Sender(id: "", displayName: "")
    
    //virtualnurse is the person currentUser will be talking to
    var virtualNurse = Sender(id: "", displayName: "")
    
    // stores text of user speaking
    var userSpeech = UITextView()
    
    //Mic button styles
    var mbs = MicButtonStyles();
    
    
    //HELPERS
    var sttHelper = SpeechToTextHelper();
    var microsoftTranslator = MicrosoftTranslatorHelper();
    
    
    var medDialog:MedicationDialog?;
    
    var isAlertNeeded:Bool = false;

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.navigationItem.setHidesBackButton(true, animated: false);
        
        //Instantiate dialog controller
        dialogController = DialogController();
        dialogController?.patient = patient;
        
        //Set top space
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0);
        messagesCollectionView.backgroundColor = .white;
        
        //SET DEFAULT NAV ITEM
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"chat_settings_nav"), style: .plain, target: self, action: #selector(self.DisplaySettings));
        self.navigationItem.leftBarButtonItem?.tintColor = .white;
        
        //REQUEST PERMISSION FOR SPEECH
        sttHelper.speechRecognizer?.delegate = self;
        sttHelper.requestSpeechAuthorization();
        sttHelper.delegate = self;
        var localecode = UserDefaults.standard.value(forKey: "language") as! String?;
        if localecode == nil || localecode == "en"{
            UserDefaults.standard.setValue("en", forKey: "language");
            changeSpeechLocale(code: "en");
        }
        else{
            changeSpeechLocale(code: localecode!)
        }
        

        //TODO: CHANGE ID AND DISPLAY NAME PROPERLY
        currentUser = Sender(id: "NRIC", displayName: "\(patient!.name)");
        virtualNurse = Sender(id: "Nurse", displayName: "Virtual Nurse");
        
        //SET DELEGATES
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        //STILL TESTING
        dialogController?.Botdelegate = self;
        
        
        
        setGreeting();
        
        
        //Set mic style by default
        micBtnStyle();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if isAlertNeeded
        {
            heartDiseaseAlert();
        }
    }
    
    @objc func DisplaySettings()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "VNStoryboard", bundle:nil)
        let csvc = storyBoard.instantiateViewController(withIdentifier: "chatSetting") as! ChatSettingsViewController
        self.navigationController?.pushViewController(csvc, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var isGreetingDialog:Bool = false;
    //Will set greeting to user;
    func setGreeting()
    {
        isGreetingDialog = true;
        let gd =   dialogController?.defaultGreeting(patient: patient!);
        gd?.paDelegate = dialogController;
        gd?.brDelegate = dialogController;
        
         gd?.greetPatient();
        Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:3)!, repeats: false) { (_) in
            
            gd?.getAppointment();
            gd?.apptDialog?.paDelegate = self.dialogController;
            gd?.apptDialog?.brDelegate = self.dialogController;
            gd?.apptDialog?.getDialog();
            
            //self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
            Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:9)!, repeats: false) { (_) in
                
                //self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
                gd?.getMonitoringLog();
                gd?.monitoringDialog?.paDelegate = self.dialogController;
                gd?.monitoringDialog?.brDelegate = self.dialogController;
                gd?.monitoringDialog?.getDialog();
                self.isGreetingDialog = false;


            }
            
        };
        
    }
    
    /*
     Function is called when patient got chance of heart disease
     Nurse will ask to remind patient to take their medication
     */
    func heartDiseaseAlert()
    {
        
            self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
            Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:2)!, repeats: false) { (_) in
                self.dialogController?.alertDialogs(patient: self.patient!);
                self.isAlertNeeded = false;
            }
        
        
        
    }

    func sendMessage(message:MockMessage)
    {
        
        // messages.append(MockMessage(text: "test123", sender: currentSender(), messageId: UUID().uuidString, date: Date()))
        messages.append(message);
        messagesCollectionView.insertSections([messages.count - 1])
        if messages.count > 0 {
            messagesCollectionView.scrollToBottom();
        }
        
    }
    
    
//===========================================================================================================
    
    
    //STYLE FOR MIC BUTTON
    @objc func micBtnStyle()
    {
        
        //HVVE A NAV BUTTON ITEM TO CHANGE TO KEYBOARD LAYOUT
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"keyboard_nav_item"), style: .plain, target: nil, action: #selector(defaultKeyboardStyle));
        self.navigationItem.rightBarButtonItem?.tintColor = .white;
        
      
        let mib = mbs.micIconStyle();
        mbs.micBtn?.onSelected({ _ in
                self.listeningBtnStyle();

        })
        messageInputBar = mib;
        
        reloadInputViews(); //REFRESH THE VIEW
        
    }
 
    //STYLE FOR LISTENING BUTTON
    func listeningBtnStyle()
    {
        
        let lib = mbs.ListeningBtnStyle();
        
        mbs.listeningBtn?.onSelected{ _ in
                       // self.sendMessage(message: MockMessage(text: self.userSpeech.text, sender: self.currentUser, messageId: UUID().uuidString, date: Date()));
                        //TODO
                        //ONCE SEND AND DISPLAY ON UI
                        //SEND TEXT TO LUIS FOR FEEDBACK
                        //self.playBotFeedback(text: self.userSpeech.text);
            self.getNurseResponse(patientquery: self.userSpeech.text);
        }
    
        mbs.listeningBtn?.onDeselected { _ in
                    lib.topStackView.arrangedSubviews.first?.removeFromSuperview();
                    lib.topStackViewPadding = .zero;
                    ////stop STT, and display mic btn ui
            
                    self.micBtnStyle();
                }
        
                mbs.cancelListeningBtn?.onSelected {
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    //when is cancel btn is clicked,change style
                    //and stop speechtotext
        
        
                }
                mbs.cancelListeningBtn?.onDeselected {
                    $0.transform = CGAffineTransform.identity
                    lib.topStackView.arrangedSubviews.first?.removeFromSuperview();
                    lib.topStackViewPadding = .zero;
                    //stop STT, and display mic btn ui
                    self.startSpeechToText()
                    self.micBtnStyle();
                };
        
    
        messageInputBar = lib;
        
        userSpeech.text = "Listening";
        userSpeech.font = UIFont.boldSystemFont(ofSize: 12)
        userSpeech.backgroundColor = .white;
        userSpeech.isScrollEnabled = false;
        userSpeech.isEditable = false;
        lib.topStackView.addArrangedSubview(userSpeech)
        lib.topStackView.sizeToFit();
        //lib.topStackViewPadding.top = 6;
        
        //When ever listening UI btn style is showing
        //App is getting user speech
        startSpeechToText();//ONCE LUIS DONE, THEN SET UP SPEECH TO TEXT
        
        reloadInputViews();
    }
    
    //Default keyboard style
    //CHANGE STYLE ??
    @objc func defaultKeyboardStyle()
    {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"mic_nav_item"), style: .plain, target: nil, action: #selector(micBtnStyle));
        self.navigationItem.rightBarButtonItem?.tintColor = .white;
        
        let newMessageInputBar = MessageInputBar()
        newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar

        self.messageInputBar.topStackViewPadding = .init(top: 5, left: 5, bottom: 5, right: 5);
        
        reloadInputViews()
    }
    
    
    /*
     Start getting user speech and display on UI
     */
    func startSpeechToText(){
        
        if sttHelper.audioEngine.isRunning//if speech to text is running
        { //stop speechtotext
            sttHelper.audioEngine.stop();
            sttHelper.recognitionRequest?.endAudio();
            self.micBtnStyle();//when speech to text not running,mic style is always shown
            sttHelper.SpeakingTimer = Timer();
            
            
        }
        else
        {
            //pass textview inside to update UI
            sttHelper.isUserSpeaking = false;
            sttHelper.startRecordingUserSpeech(userSpeech:userSpeech);//start
            sttHelper.AutoDetectUserSpeaking(2.5);//Set autodetection
            
        }
        
    }
    
    /*
     Send patient text to Nurse
     and get Nurse response
     */
    func getNurseResponse(patientquery:String)
    {
        
        //check what language user is speaking
        var localecode = UserDefaults.standard.value(forKey: "language") as! String;
        if localecode == nil
        {
            localecode = "en";
        }
        dialogController?.query(text: patientquery, language: localecode);
        
//        //Query from LUIS
//        //GET
//        dialogController?.query(text: patientquery, onComplete: { (response) in
//
//            //Remove the ... from array
//            self.messages.removeLast();
//
//            if response.isPrompt{ //if the question is a prompt
//                //pass the dialog response to the prompt delegate
//                self.dialogController?.Botdelegate.isPromptQuestion(promptDialog: response);
//            }
//
//
//            //GET DIALOG AND PLACE IN UI
//            let responseToDisplay = response.responseToDisplay;
//            let botspeakmessage = response.BotResponse;
//            print("nurse responded : \(responseToDisplay)");
//            //let Botresponse = response.BotResponse; // this will when bot speaks
//            DispatchQueue.main.async {
//                //Update UI to remove ... and insert nurse response
//
//                self.messagesCollectionView.deleteSections([self.messages.count]);
//
//
//                for botspeak in botspeakmessage
//                {
//                    //call bot speak also
//                    self.sttHelper.delegate?.BotSpeak(text: botspeak, translationRequired: false);
//                }
//
//                for response in responseToDisplay //display messages in loop
//                {
//                    self.sendMessage(message: MockMessage(text:response, sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
//
//
//                }
//            }
//
//
//        })
    }

    func changeSpeechLocale(code:String)
    {
        print("locale for mic is \(code)");
        sttHelper.speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: code));
    }
    
    
}//end class


//===========================================================================================================




//TODO,TEST FIRST
extension ChatViewController:BotResponseDelegate
{
    
    
    
    func receivedMedication(responseDialog: MedicationDialog,response:Bool) {
        //once get medication dialog
        //set delegate
        print("****** it is medicine *****");
        
        medDialog = responseDialog;
        if response {
            medDialog?.imagePickerController.sourceType = .camera
            medDialog?.imagePickerController.delegate = self;
            
            present((medDialog?.imagePickerController)!, animated: true, completion: nil)
        }
        else{
            medDialog?.askForSearchNo();
            dialogController?.Botdelegate.recievedPromptResponse(responseDialog: medDialog!);
            
        }
       
        
    }
    
    func display(response: Dialog) {
        
        print("DISPLAY");
        
        
        
        
        if messages.count > 0 {
            //Remove; the ... from array
            self.messages.removeLast();
        }
       
        if response.isPrompt{ //if the question is a prompt
            //pass the dialog response to the prompt delegate
            self.dialogController?.Botdelegate.isPromptQuestion(promptDialog: response);
        }
        
                    DispatchQueue.main.async {
                        //Update UI to remove ... and insert nurse response
                        if self.messages.count > 0{
                                self.messagesCollectionView.deleteSections([self.messages.count]);
                        }
                        
                       
        
        
                        for botspeak in response.BotResponse
                        {
                            //call bot speak also
                            self.sttHelper.delegate?.BotSpeak(text: botspeak, translationRequired: false);
                        }
        
                        for response in response.responseToDisplay //display messages in loop
                        {
                            self.sendMessage(message: MockMessage(text:response, sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
        
        
                        }
                        
                        if self.isGreetingDialog{
                            self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
                        }
                    }
    }
    
    //Function is called if nurse is asking a prompt question to patient
    func isPromptQuestion(promptDialog: Dialog) {
        print("****** BOT RESPONDED WITH A PROMPT QUESTION");
        
        //DISPLAY THE YES/NO UI
        DispatchQueue.main.async {
            self.messageInputBar.inputTextView.isEditable = false
            let Promptview = PromptChatView();
            //TODO: HAVE A BG COLOR FOR BUTTONS
            //SET THE HANDLER FROM THE DIALOG
            Promptview.yesButton?.addTarget(promptDialog, action: #selector(promptDialog.promptHandler), for: .touchUpInside);
            Promptview.noButton?.addTarget(promptDialog, action: #selector(promptDialog.promptHandler), for: .touchUpInside);
            
            self.messageInputBar.topStackView.addArrangedSubview(Promptview);
        }
        
    }
    
    //Once patient has responed the the prompt dialog
    //will get response here
    func recievedPromptResponse(responseDialog: Dialog) {
        
            
            self.messageInputBar.inputTextView.isEditable = true;
            
            //remove the topstackview
            self.messageInputBar.topStackView.subviews.forEach({$0.removeFromSuperview()});
            
            
            //GET DIALOG AND PLACE IN UI
            let responseToDisplay = responseDialog.responseToDisplay;
            print("nurse prompt responded : \(responseToDisplay)");
            let Botresponse = responseDialog.BotResponse; // this will when bot speaks
            
            
            self.sendMessage(message: MockMessage(text:responseToDisplay.last!, sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
        self.sttHelper.delegate?.BotSpeak(text: Botresponse.last!, translationRequired: false);

        }
        
       
    

}

//MARK: - Speech detection delegate

extension ChatViewController:SpeechDetectionDelegate
{
    
    func BotSpeak(text: String, translationRequired: Bool) {
        
        print("*********BOT SPEAK ************");
        print("BOT SAID \(text)");
        //call microsoft
        
        
        //if en is default, no need translation,speak can already
        var localecode = UserDefaults.standard.value(forKey: "language") as! String;
        if localecode == nil
        {
            localecode = "en";
        }
        
        
        MicrosoftTranslatorHelper.Speak(text: text, language: localecode);
    }
    
    
    func User(hasNeverSpoke: Bool) {
        if hasNeverSpoke{
            //stop speech to text
            print("********USER HAS NEVER SPOKE****")
            startSpeechToText();
        }
    }
    
    func User(hasFinishedSpeaking: Bool) {
        if hasFinishedSpeaking{
            //send text to query
            print("*************USER HAS SPOKE AND FINISHED SPEAKING*************")
            startSpeechToText();
            
            self.sendMessage(message: MockMessage(text:userSpeech.text, sender: self.currentUser, messageId: UUID().uuidString, date: Date()));
            //SEND TEXT TO QUERY
            Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:1)!, repeats: false) { (_) in
                
                self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
                self.getNurseResponse(patientquery: self.userSpeech.text);
                
            };
        }
    }
    
    
}

//===========================================================================================================

// MARK: - MessagesDataSource

extension ChatViewController : MessagesDataSource
{
    
    //Must have
    /*
     Determine who is the current user
     */
    func currentSender() -> Sender {
        return self.currentUser;
    }
    
    //Must have
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section];//for messages,is done by sections not rows
    }
    
    //Must have
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count;//return no. of messages
    }
    
    //Avatar image for chat bubble
//    func avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
//        return Avatar();
////        if isFromCurrentSender(message: message)
////        {
////            return Avatar(initials: "PT");
////        }
////        else{
////            return Avatar(image: UIImage(named:"Nurse_Logo"), initials: "Bot");
////        }
//    }
    
    //remove avatar
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        struct ConversationDateFormatter {
            static let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter
            }()
        }
        let formatter = ConversationDateFormatter.formatter
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}


// MARK: - MessageInputBarDelegate

//HANDLE INPUT WHEN USER TYPES ON TEXT BOX
extension ChatViewController: MessageInputBarDelegate {
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        //create text with style
//        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 8), .foregroundColor: UIColor.blue])
        
        self.sendMessage(message: MockMessage(text:text, sender: self.currentUser, messageId: UUID().uuidString, date: Date()));
        
        print("patient asked \(text)");
  
        //display ... and get nurse response after 1 sec of getting patient query
        Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:1)!, repeats: false) { (_) in
            
            self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
            self.getNurseResponse(patientquery: text);
            
        };
        inputBar.inputTextView.text = String()//Clear textfield
    }
    
}

//MARK: - MessagesLayoutDelegate
//To set layout for messages
extension ChatViewController: MessagesLayoutDelegate {
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 200;
    }
    
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .natural, vertical: .messageBottom)
    }
    
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isFromCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }
    
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        } else {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }
}

//MARK: -MessagesDisplayDelegate

//TO set display style for message bubble
extension ChatViewController : MessagesDisplayDelegate
{
    
    //set bg color for bubble
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        if isFromCurrentSender(message: message)
        {
            //return .green;
            return UIColor(red: 54, green: 150, blue: 247);
        }
        else
        {
            //return .white;
            return UIColor(red: 244, green: 244, blue: 244);
            
        }
//        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        //if is currentsender, text color is white
        // if is bot, text color is dark
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    //setting bubble tail
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func messageHeaderView(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageHeaderView {
        let header = messagesCollectionView.dequeueReusableHeaderView(MessageDateHeaderView.self, for: indexPath);
        
        
        header.dateLabel.text = MessageKitDateFormatter.shared.string(from: message.sentDate)
        
        return header;
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return false }
        if indexPath.section == 0 { return true }
        let previousSection = indexPath.section - 1
        let previousIndexPath = IndexPath(item: 0, section: previousSection)
        let previousMessage = dataSource.messageForItem(at: previousIndexPath, in: messagesCollectionView)
        let timeIntervalSinceLastMessage = message.sentDate.timeIntervalSince(previousMessage.sentDate)
        return timeIntervalSinceLastMessage >= messagesCollectionView.showsDateHeaderAfterTimeInterval
    }
    
    
}




//MARK: - SFSpeechRecognizerDelegate
extension ChatViewController:SFSpeechRecognizerDelegate
{
    //need to make sure speech recognition is available when creating speech recognition task
    //must add a delegate method
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available
        {
            // if user accept
            //set mic style by default
            print("SPEECH GRANTED");
            
        }
        else // if user does not accept
        {
            //set normal keyboar layout by default
            print("SPEECH DENIED");
        }
    }
}

/**
 Will be called when is for medication dialog to process medicine search
 
 */
extension ChatViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil);
        //display message if patient never send picture
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard  let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {fatalError("Expected an image, but was provided \(info)")}
        
        self.messageInputBar.topStackView.subviews.forEach({$0.removeFromSuperview()});
        //get image and pass to chat
        dismiss(animated: true, completion: nil) // dismiss the image picker
        
        //display image in chat
        sendMessage(message: MockMessage(image: selectedImage, sender: currentUser, messageId: UUID().uuidString, date: Date()));
        
        //process image an display dialog
        //call medicine search prediction
        Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:1)!, repeats: false) { (_) in
            //remove the topstackview
            
            self.sendMessage(message: MockMessage(text:"...", sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
            self.medDialog?.searchMedicine(image: selectedImage, onComplete: { (md) in
                //once processed finished
                DispatchQueue.main.async {
                    self.messages.removeLast();
                    self.messagesCollectionView.deleteSections([self.messages.count]);
                    
                    
                    self.dialogController?.Botdelegate.recievedPromptResponse(responseDialog: md);
                }
               
            })
            //Remove; the ... from array
        };
        
        
        
    }
}



//UICOLOR EXTENSION
//TODO : PUT ALL UICOLOR EXTENSION UNDER ONE CLASS
extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
