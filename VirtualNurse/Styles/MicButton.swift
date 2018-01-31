//
//  MicButtonStyle.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 26/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import MessageKit


class MicInputBar: MessageInputBar {
    
    
    
    override open lazy var inputTextView: InputTextView = { [weak self] in
        let textView = InputTextView()
        //textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.messageInputBar = self
        textView.messageInputBar = nil; // remove the inputtextView
        return textView
        }()
    
    override func textViewDidBeginEditing() {
        self.inputTextView.isEditable = false;
    }
    
    
    
    //ovveride the function
    override func textViewDidChange() {
        
        let trimmedText = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //sendButton.isEnabled = !trimmedText.isEmpty
        inputTextView.placeholderLabel.isHidden = !inputTextView.text.isEmpty
        
        items.forEach { $0.textViewDidChangeAction(with: inputTextView) }
        
        delegate?.messageInputBar(self, textViewTextDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    
    
//    override open lazy var sendButton: InputBarButtonItem = {
//        return InputBarButtonItem()
//            .configure {
//                $0.image = UIImage(named:"Mic_Style");
//                $0.setSize(CGSize(width: 52, height: 28), animated: false)
//                $0.isEnabled = true
//                //$0.title = "Hello"
//                //$0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
//            }
//    }()
    
    
}
