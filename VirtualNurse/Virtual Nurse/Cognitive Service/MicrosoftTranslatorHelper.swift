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
    let audioSession = AVAudioSession.sharedInstance();
    
    func Translate(from:String,to:String,text:String)
    {
        let f = from.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        let t = from.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        let txt = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        
        let url = URL(string: "https://api.microsofttranslator.com/V2/Http.svc/Translate?text=\(txt)&to=en&from=en&contentType=text/plain");
        var u = URLRequest(url: url!);
        u.addValue("de07fd275ef34f0887cb1113d3dcca47", forHTTPHeaderField: "Ocp-Apim-Subscription-Key");
        
        
        let task = URLSession.shared.dataTask(with: u) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
            print(data);
            let parser = XMLParser(data: data)
            parser.delegate = self
            // print(response);
            
            if parser.parse() {
                print("parsed");
            }
        }
        task.resume()
    }
    
    func Speak(text:String)
    {
        
        let url = URL(string: "https://api.microsofttranslator.com/V2/Http.svc/Speak?language=en&text=\(text)&format=audio/mp3");
        var u = URLRequest(url: url!);
        u.addValue("de07fd275ef34f0887cb1113d3dcca47", forHTTPHeaderField: "Ocp-Apim-Subscription-Key");
        
        let task = URLSession.shared.dataTask(with: u) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
            do {
                try self.audioSession.setCategory(AVAudioSessionCategorySoloAmbient)
                try self.audioSession.setMode(AVAudioSessionModeDefault)
                
                self.player = try AVAudioPlayer(data: data);
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
    // initialize results structure
    
    func parserDidStartDocument(_ parser: XMLParser) {
        // results = []
    }
    
    // start element
    //
    // - If we're starting a "record" create the dictionary that will hold the results
    // - If we're starting one of our dictionary keys, initialize `currentValue` (otherwise leave `nil`)
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
    }
    
    // found characters
    //
    // - If this is an element we care about, append those characters.
    // - If `currentValue` still `nil`, then do nothing.
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //  currentValue? += string
        print(string);
        var text = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
        Speak(text:text!);
        
        // // if after xx seconds, no respond from textview
        // stop speech
        
    }
    
    // end element
    //
    // - If we're at the end of the whole dictionary, then save that dictionary in our array
    // - If we're at the end of an element that belongs in the dictionary, then save that value in the dictionary
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
}





