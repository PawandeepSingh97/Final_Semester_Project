//
//  helperClass.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 5/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation

//A class which consist of command methods
class helperClass{
    
    //Get today's date
    func getTodayDate() ->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    //Set label currentDate
    func setDateLabelCurrentDate()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        let str = formatter.string(from: date)
        return str
    }
    

    
    
 
    
    
    
}
