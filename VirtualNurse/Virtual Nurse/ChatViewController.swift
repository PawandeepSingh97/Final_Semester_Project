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
    
    //HELPERS
    var sttHelper = SpeechToTextHelper();
    var microsoftTranslator = MicrosoftTranslatorHelper();
    
    //to test speech recognizer,remove later
    //var FLAG:BOOL = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //Instantiate dialog controller
        dialogController = DialogController();
        dialogController?.patient = patient;
        
        //Set top space
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0);
        
        //SET DEFAULT NAV ITEM
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"chat_settings_nav"), style: .plain, target: nil, action: nil);
        self.navigationItem.leftBarButtonItem?.tintColor = .white;
        
        //REQUEST PERMISSION FOR SPEECH
        sttHelper.speechRecognizer?.delegate = self;
        sttHelper.requestSpeechAuthorization();
        sttHelper.delegate = self;
        
      //  messagesCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "Blue-Gradient BG")!);//BG COLOR
        messagesCollectionView.backgroundColor = .white;
        
        //wself.view.backgroundColor = UIColor(patternImage: UIImage(named: "Blue-Gradient BG")!);
        //navigationController?.setNavigationBarHidden(false, animated: true);
        
        //TODO: CHANGE ID AND DISPLAY NAME PROPERLY
        currentUser = Sender(id: "NRIC", displayName: "\(patient!.name)");
        virtualNurse = Sender(id: "Nurse", displayName: "Virtual Nurse");
        
        //SET DELEGATES
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        //STILL TESTING
        //dialogController?.delegate = self;
        
        
        //TODO
        //hardcode message, each messageID,MUST BE UNIQUE
        //REMOVE ONCE,TESTING FINISH
        let m1 = MockMessage(text: "Hi \(patient!.name) \n soon will set up auto greeting and many more ^_^.", sender: virtualNurse, messageId: "2", date: Date());
        let mm = MockMessage(text: "Hello nurse", sender: currentUser, messageId: "1", date: Date());
        messages.append(m1);
        messages.append(mm);
        
        
        //Set mic style by default
        //REMOVE THIS,ONCE TESTING DONE
        micBtnStyle();
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Will set greeting to user;
    func setGreeting()
    {
        
    }

    func sendMessage(message:MockMessage)
    {
        // messages.append(MockMessage(text: "test123", sender: currentSender(), messageId: UUID().uuidString, date: Date()))
        messages.append(message);
        messagesCollectionView.insertSections([messages.count - 1])
        messagesCollectionView.scrollToBottom()
    }
    
    
    /*
     - Start SpeechToText
     */
    func startSpeechToText(_ userSpeech:UITextView)
    {
        if sttHelper.audioEngine.isRunning//if audio is recording
        {   //stop speechtotext
            sttHelper.audioEngine.stop();
            sttHelper.recognitionRequest?.endAudio();
            print("\n RECORDING STOP \n")
        }
        else
        {
            print("\n RECORDING START \n");
                                            //pass label inside to show user
            sttHelper.startRecordingUserSpeech(userSpeech:userSpeech);//start
            sttHelper.AutoDetectUserSpeaking(2.5);//Set autodetection
        }
    }

    
    //function will take in text and speak to user
    //based on preferred language
    func playBotFeedback(text:String)
    {
        
        
        dialogController?.query(text: text, onComplete: { (response) in
            //once get response
            //display in UI
            DispatchQueue.main.async
                {
                     self.sendMessage(message: MockMessage(text:response, sender: self.virtualNurse, messageId: UUID().uuidString, date: Date()));
                  //  self.sttHelper.myUtterance = AVSpeechUtterance(string:response)
                    // self.myUtterance.rate = 0.5
                  //  self.sttHelper.synth.speak(self.sttHelper.myUtterance);
                    
            }
            self.microsoftTranslator.Translate(from: "en", to: "en", text: response);
            
            
        })
    }

    // UI MIC BTN STYLE
//===========================================================================================================
    
    //STYLE FOR MIC BUTTON
    @objc func micBtnStyle()
    {
        //HVVE A NAV BUTTON ITEM TO CHANGE TO KEYBOARD LAYOUT
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"keyboard_nav_item"), style: .plain, target: nil, action: #selector(defaultKeyboardStyle));
        self.navigationItem.rightBarButtonItem?.tintColor = .white;
        
        let mib = MicInputBar();//CUSTOM MESSAGE INPUT BAR
        mib.sendButton.isHidden = true;//set to hidden,since no need
        mib.separatorLine.isHidden = true;//remove seperator line from view
        
        //SET BACKGROUND TO BE TRANSPARENT
        mib.backgroundView.backgroundColor = UIColor.clear;
        mib.isOpaque = false;
        
        //BUTTON FOR MIC
        let micbtn = InputBarButtonItem();
        micbtn.image = UIImage(named:"Mic_Style");
        micbtn.center = self.view.center;
        micbtn.setSize(CGSize(width: 100, height: 100), animated: false);
        
        //WHEN MICBTN SELECTED WILL DISPLAY THE UI FOR LISTENING TO USER UI
        micbtn.onSelected {
            $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            let label = UILabel()
            label.text = "Listening";
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.backgroundColor = .white;
            mib.topStackView.addArrangedSubview(label)
            mib.topStackViewPadding.top = 6;
            //when selected,change to listening style
            self.listeningBtnStyle();
        };
        micbtn.onDeselected {
            $0.transform = CGAffineTransform.identity
            mib.topStackView.arrangedSubviews.first?.removeFromSuperview();
            mib.topStackViewPadding = .zero;
        };
        
        //let emptyBtn = InputBarButtonItem();
        //        let keyboardBtn = InputBarButtonItem();
        //        keyboardBtn.image = UIImage(named:"keyboard_nav_item");
        //        keyboardBtn.center = self.view.center;
        //        keyboardBtn.setSize(CGSize(width: 100, height: 100), animated: false);
        
        // Since we moved the send button to the bottom stack lets set the right stack width to 0
        //  mib.setRightStackViewWidthConstant(to: 0, animated: true)
        //let btnItems = [emptyBtn,micbtn,keyboardBtn];
        // Finally set the items
        //mib.bottomStackView.distribution = .fillEqually;
        
        let btnItems = [micbtn];
        mib.setStackViewItems(btnItems, forStack: .bottom, animated: false);
        messageInputBar = mib;
        reloadInputViews(); //REFRESH THE VIEW
        
    }
    
    var userSpeech = UITextView()
    
    //STYLE FOR LISTENING BUTTON
    func listeningBtnStyle()
    {
        let lib = MicInputBar();
        lib.sendButton.isHidden = true;
        lib.separatorLine.isHidden = true;
        //SET BACKGROUND TO BE TRANSPARENT
        lib.backgroundView.backgroundColor = UIColor.white;
        lib.isOpaque = false;
        
        self.userSpeech = UITextView();
        
        let listeningBtn = InputBarButtonItem();
        listeningBtn.title = "LISTENING";
        listeningBtn.contentHorizontalAlignment = .left;
        listeningBtn.onSelected { (btn) in
            
            self.sendMessage(message: MockMessage(text: self.userSpeech.text, sender: self.currentUser, messageId: UUID().uuidString, date: Date()));
            //TODO
            //ONCE SEND AND DISPLAY ON UI
            //SEND TEXT TO LUIS FOR FEEDBACK
            self.playBotFeedback(text: self.userSpeech.text);
        }
        listeningBtn.onDeselected { (btn) in
            lib.topStackView.arrangedSubviews.first?.removeFromSuperview();
            lib.topStackViewPadding = .zero;
            ////stop STT, and display mic btn ui
            self.startSpeechToText(self.userSpeech)
            self.micBtnStyle();
        }
        
        
        let cancelBtn = InputBarButtonItem();
        cancelBtn.image = UIImage(named:"Cancel_Listening_Chat");
        cancelBtn.setSize(CGSize(width: 20, height: 20), animated: false);
        cancelBtn.onSelected {
            $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            //when is cancel btn is clicked,change style
            //and stop speechtotext
            
            
        }
        cancelBtn.onDeselected {
            $0.transform = CGAffineTransform.identity
            lib.topStackView.arrangedSubviews.first?.removeFromSuperview();
            lib.topStackViewPadding = .zero;
            //stop STT, and display mic btn ui
            self.startSpeechToText(self.userSpeech)
            self.micBtnStyle();
        };
        
        //cancelBtn.title = "CANCEL";
        //change to image
        
        
        let btnItems = [listeningBtn,cancelBtn];
        lib.setStackViewItems(btnItems, forStack: .bottom, animated: false);
        lib.padding.bottom = 10;
        messageInputBar = lib;
        
        
        userSpeech.text = "Listening";
        userSpeech.font = UIFont.boldSystemFont(ofSize: 12)
        userSpeech.backgroundColor = .white;
        userSpeech.isScrollEnabled = false;
        lib.topStackView.addArrangedSubview(userSpeech)
        lib.topStackView.sizeToFit();
        //lib.topStackViewPadding.top = 6;
        
        //When ever listening UI btn style is showing
        //App is getting user speech
        startSpeechToText(userSpeech);
        
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
        reloadInputViews()
    }
    
    
}//end class


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
    func avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
        if isFromCurrentSender(message: message)
        {
            return Avatar(initials: "PT");
        }
        else{
            return Avatar(image: UIImage(named:"Nurse_Logo"), initials: "Bot");
        }
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
        
        let id = UUID().uuidString//GET UNIQUE ID
        let message = MockMessage(text: text, sender: currentSender(), messageId: id, date: Date())
        messages.append(message)
        inputBar.inputTextView.text = String()//Clear textfield
  
        
        //INSERT CHAT AT END OF MESSAGE
        messagesCollectionView.insertSections([messages.count - 1])
        messagesCollectionView.scrollToBottom()
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

//TODO,TEST FIRST
//extension ChatViewController:BotResponseDelegate
//{
////    func BotResponse(get: Dialog) -> String {
////        print(get.getDialog());
////        return get.getDialog();
////    }
//}

extension ChatViewController:SpeechDetectionDelegate
{
    func User(hasNeverSpoke: Bool) {
        if hasNeverSpoke{ //stop speech
            
            if sttHelper.audioEngine.isRunning//if audio is recording
            {   //stop speechtotext
                sttHelper.audioEngine.stop();
                sttHelper.recognitionRequest?.endAudio();
                print("\n RECORDING STOP \n")
                self.micBtnStyle();
                sttHelper.isUserSpeaking = false;
                sttHelper.SpeakingTimer = Timer()
            }
            
            print("NEVER SPOKE");
            
        }
    }
    
    func User(hasFinishedSpeaking: Bool) {
        if hasFinishedSpeaking // stop and send message
        {
            
            if sttHelper.audioEngine.isRunning//if audio is recording
            {   //stop speechtotext
                sttHelper.audioEngine.stop();
                sttHelper.recognitionRequest?.endAudio();
                print("\n RECORDING STOP \n")
                
                self.sendMessage(message: MockMessage(text: userSpeech.text, sender: self.currentUser, messageId: UUID().uuidString, date: Date()));
                //TODO
                //ONCE SEND AND DISPLAY ON UI
                //SEND TEXT TO LUIS FOR FEEDBACK
                self.playBotFeedback(text: userSpeech.text);
                self.micBtnStyle();
            }
        }
        
        print("HAS SPOKEN");
    }
    
    func checkIf(isUserSpeaking: Bool, test: String) {
        //
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
