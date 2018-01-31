//
//  Entity.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 30/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation

class Entity
{
    
    var entityFromUtterence:String?; //what entity mention from user
    var entityType:String?; //what entity type is it
    var entityValues:[String]?; //stores the value of entity
    

    var dates:[Date]?;//stores date
    
    init(efu:String,et:String,ev:[String]) {
        entityFromUtterence = efu;
        entityType = et;
        entityValues = ev;
    }
    
}
