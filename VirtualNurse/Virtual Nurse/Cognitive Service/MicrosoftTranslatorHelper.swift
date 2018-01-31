//
//  MicrosoftTranslatorHelper.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 24/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation
import AVFoundation

class MicrosoftTranslatorHelper : NSObject
{
    var player:AVAudioPlayer?;
    var convertedText = "";
    var bool = false;
    
    
    /**
     Translate from one language to another
     */
    func Translate(from:String,to:String,text:String,onComplete:((_:String) -> Void)?)
    {
        //allow url encoding
        let f = from.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        let t = to.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        let txt = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        
        
        
        let url = URL(string: "\(RestfulController.MicrosoftTranslateEndPoint())?text=\(txt)&to=\(t)&from=\(f)&contentType=text/plain");
        var u = URLRequest(url: url!);
        u.addValue("de07fd275ef34f0887cb1113d3dcca47", forHTTPHeaderField: "Ocp-Apim-Subscription-Key");
        
        
        let task = URLSession.shared.dataTask(with: u) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

                //GET LANGUAGE TEXT FROM XML
                let parser = XMLParser(data: data)
                parser.delegate = self
                // print(response);
                
                if parser.parse() {
                    print("parsed");
                }
            onComplete?(self.convertedText);
            
        }
        task.resume()
    }
    
    /*
     Speak Text in Specified Language
     */
    func Speak(text:String,language:String)
    {
        
        let txt = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        let lng = language.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
        let url = URL(string: "\(RestfulController.MicrosoftSpeakEndPoint())?language=\(lng)&text=\(txt)&format=audio/mp3");
        
        var u = URLRequest(url: url!);
        u.addValue("de07fd275ef34f0887cb1113d3dcca47", forHTTPHeaderField: "Ocp-Apim-Subscription-Key");
        
        let task = URLSession.shared.dataTask(with: u) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
            do {
                self.player = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.mp3.rawValue);
                self.player?.prepareToPlay()
                self.player?.volume = 1.0
                self.player?.play()
            }
            catch{
                print("error")
            }
            
        }
        task.resume()
    }
    
    
    
    // Just in case, if there's an error, report it. (We don't want to fly blind here.)
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
    
}

extension MicrosoftTranslatorHelper:XMLParserDelegate
{
    
    // found characters
    //
    // - If this is an element we care about, append those characters.
    // - If `currentValue` still `nil`, then do nothing.
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //  currentValue? += string
        print(string);
        convertedText = string;//GET CONVERTED TEXT
//        var text = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
//        if bool
//        {
//                Speak(text:convertedText);
//        }
        
        
        // // if after xx seconds, no respond from textview
        // stop speech
        
    }
}





