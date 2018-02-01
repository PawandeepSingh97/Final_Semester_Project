//
//  SpeechToTextHelper.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 28/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import Speech

/*
 ENSURE IN INFO.PLIST
 FOLLOWING KEYS ARE ADDED :
 
  NSSpeechRecognitionUsageDescription - "Allow Speech recognition ? "
  NSMicrophoneUsageDescription - "Your microphone will be used."
 */

protocol SpeechDetectionDelegate
{
    func User(hasNeverSpoke:Bool);
    func User(hasFinishedSpeaking:Bool)
    func BotSpeak(text:String,translationRequired:Bool);
}

class SpeechToTextHelper: NSObject {
    
    var SpeakingTimer = Timer();//Used to check how long user has spoke or how long it never spoke
    var isUserSpeaking = false; //used to check if user is speaking or not
    var delegate:SpeechDetectionDelegate?
    var language:String = "en";
    

    //let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()//will do actual speech recognition
    //can fail to recognize speech and return nil,best use optional; or for different language
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en"))
    //zh-CN,ms-MY
    
     var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?//handles the speech recognition requests,provides an audio input to the speech recognizer.
    
    //ALLOWS to cancel,start,stop speech
     var recognitionTask: SFSpeechRecognitionTask?
    
     let audioEngine = AVAudioEngine() //responsible for providing your audio input
    
    
    //for text to speech
    let synth = AVSpeechSynthesizer();
    var myUtterance = AVSpeechUtterance(string: "")
    
    //set up requests,disabled buttion if authorization failed
    //ensure info.plist have Privacy - Speech Recognition Usage Description
    // Privacy - Microphone Usage Description
    
    
    func requestSpeechAuthorization()
    {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
//            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                print("speech authorized");
                //isButtonEnabled = true
                
            case .denied:
               // isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                //isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                //isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
//            OperationQueue.main.addOperation() {
//              //  self.startstopBtn.isEnabled = isButtonEnabled
//            }
        }
    }
    
    
    func startRecordingUserSpeech(userSpeech:UITextView)
    {
        print("STARTING");
        //check if recognitionTask is running,if so cancel task and recognition
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        //Prepare for audio recording
        let audioSession = AVAudioSession.sharedInstance()
        do {
         
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord);
            try audioSession.overrideOutputAudioPort(.speaker);
            try audioSession.setActive(true)
            
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        //use to pass audio data to apple servers2
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        //check if audioEngine has audio input for recording
        let inputNode = audioEngine.inputNode
        //check if object is instantaited and is not nil
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        //tell it to report partial result of speech recongintion as user speaks
        recognitionRequest.shouldReportPartialResults = true
        
        //start recongintion by calling method
        //completion handeler called every time recognition has recieved input,has refined its current recognition,or has been cancelled or stopped and will return a final transcript
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            //TODO : PASS COMPLETION HANDLER ?
            
            var isFinal = false//determine if recognition is final
            
            if result != nil {//if not nil

                if self.SpeakingTimer.isValid  // once user starts speaking
                {
                    self.isUserSpeaking = true;
                    print("User speaking");
                    self.SpeakingTimer.invalidate(); //stop timer
                    self.AutoDetectUserSpeaking(1.8);
                }
                userSpeech.text = result?.bestTranscription.formattedString;
                //and set boolean as final
                isFinal = (result?.isFinal)!
                
            }
            
            //if got no error
            if error != nil || isFinal {
                //stop audio input
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                //stop recongition request and task
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                //then enable the start recordning button
               // self.startstopBtn.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            //add audio input to recognitionRequest
            //**its okay to add audioinput after starting recognitionTask
            //Speech framework will start recognizing as soon as an audio input has been added
            self.recognitionRequest?.append(buffer)
        }
        
        //prepare and start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        
    }//end func
    
    
    var text:String = "";
    //TIMER TO AUTO-DETECT IF USER NEVER SPOKE OR ONCE USER HAS SPOKE FINISHED
     func AutoDetectUserSpeaking(_ interval:Double)
    {
        
      //  var test = "";
        
        if !isUserSpeaking // if user never speak
        {
            SpeakingTimer =  Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:interval)!, repeats: false) { (_) in
                    print("User never speak");
                self.delegate?.User(hasNeverSpoke: true);
            }
        }
        else // if user is speaking
        {
            self.delegate?.User(hasNeverSpoke: false)
            
            SpeakingTimer =   Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly:interval)!, repeats: false) { (_) in
                
                self.SpeakingTimer.invalidate();
                self.delegate?.User(hasFinishedSpeaking: true);

//                if (self.text == "Listening")
//                {
//                    self.delegate?.User(hasFinishedSpeaking: false);
//                }
//                else
//                {
//                    self.delegate?.User(hasFinishedSpeaking: true);
//                    print("User speak finish");
//                    self.SpeakingTimer.invalidate();
//                }
            }
        }
    }
    
    }

