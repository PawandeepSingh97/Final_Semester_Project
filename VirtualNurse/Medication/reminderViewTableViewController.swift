//
//  reminderViewTableViewController.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 29/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import UIKit

class reminderViewTableViewController: UITableViewController {
    
    
    var id : String = ""
    var medicineName : String = ""
    var checkEnabledOrNot : Bool?
    var morningTime : String = ""
    var afternoonTime : String = ""
    var eveningTime : String = ""
    
    var rowValues : [String] = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
            getReminders()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! reminderCustomCell
        
        
        cell.reminderLbl.text = self.rowValues[0]
     
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func getReminders() {
        var counting123 : Int = 0;
        
        MedicineDataManager().getAllReminders { (Reminder) in
            
            counting123 = counting123 + 1
            
            self.id = Reminder.id
            self.medicineName = Reminder.medicineName
            self.morningTime = Reminder.morningTime
            self.afternoonTime = Reminder.afternoonTime
            self.eveningTime = Reminder.eveningTime
            self.checkEnabledOrNot = Reminder.isEnabled
            
            self.rowValues = ["\(self.medicineName)","\(self.morningTime)","\(self.afternoonTime)","\(self.eveningTime)" ,"\(String(describing: self.checkEnabledOrNot))"]
            
            //testing purposes, please ignore
            print("Viknes DON \(self.medicineName)")
            print("TAUFIK BATISAH WWE CHAMPION \(String(describing: self.checkEnabledOrNot))")
            print("Harikesh \(self.rowValues)")
            print("Inner regions : \(counting123)")
            
        }
    }
}
