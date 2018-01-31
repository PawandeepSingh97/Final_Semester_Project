//
//  MicButtonStyles.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 28/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation
import MessageKit



class MicButtonStyles
{
    var micBtn:InputBarButtonItem?;
    
    var listeningBtn:InputBarButtonItem?;
    var cancelListeningBtn:InputBarButtonItem?;
    
    func micIconStyle() -> MessageInputBar
    {
        let mibBtn = MicInputBar();
        mibBtn.sendButton.isHidden = true;//set to hidden,since no need
        mibBtn.separatorLine.isHidden = true;//remove seperator line from view
        //SET BACKGROUND TO BE TRANSPARENT
        mibBtn.backgroundView.backgroundColor = UIColor.clear;
        mibBtn.isOpaque = false;
        
        //BUTTON FOR MIC
        micBtn = InputBarButtonItem();
        micBtn?.image = UIImage(named:"Mic_Style");
        //micbtn.center = self.view.center;
        micBtn?.setSize(CGSize(width: 100, height: 100), animated: false);
        
//        let label = UILabel()
//        label.text = "Listening";
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.backgroundColor = .white;
//        mibBtn.topStackView.addArrangedSubview(label);
//        mibBtn.topStackViewPadding.top = 6;
        
    
        let btnItems = [micBtn!];
        mibBtn.setStackViewItems(btnItems, forStack: .bottom, animated: false);
        
        
        return mibBtn;
    }
    
    
    func ListeningBtnStyle() -> MessageInputBar
    {
        let lbBtn = MicInputBar();
        lbBtn.sendButton.isHidden = true;
        lbBtn.separatorLine.isHidden = true;
        //SET BACKGROUND TO BE TRANSPARENT
        lbBtn.backgroundView.backgroundColor = UIColor.white;
        lbBtn.isOpaque = false;
        
        listeningBtn = InputBarButtonItem();
        cancelListeningBtn = InputBarButtonItem();
        
        listeningBtn?.title = "LISTENING";
        listeningBtn?.contentHorizontalAlignment = .left;
        
        cancelListeningBtn?.image = UIImage(named:"Cancel_Listening_Chat");
        cancelListeningBtn?.setSize(CGSize(width: 20, height: 20), animated: false);
        
        let btnItems = [listeningBtn!,cancelListeningBtn!];
        lbBtn.setStackViewItems(btnItems, forStack: .bottom, animated: false);
        lbBtn.padding.bottom = 10;
        
        return lbBtn;
    }
    
}
