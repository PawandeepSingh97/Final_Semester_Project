//
//  ConversationStack.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 28/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation

struct ConversationStack{
    
    fileprivate var converasationContext: [Dialog] = [];
    

    //PUSH DIALOG IN array
    mutating func push(_ element:Dialog)
    {
        converasationContext.append(element);
    }
    
    //Pop Dialog
    mutating func pop() -> Dialog? {
        
        return converasationContext.popLast()
    }
    
    //Peek Dialog
    func peek() -> Dialog? {
        return converasationContext.last
    }
    
    //REMOVE ALL ELEMENTS IN STACK
    mutating  func removeAll()
    {
        converasationContext.removeAll();
        
    }
    
    func count() -> Int
    {
        return converasationContext.count;
    }
    
}
