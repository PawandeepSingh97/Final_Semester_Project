//
//  UpdateAppointmentViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 7/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import FSCalendar;

class UpdateAppointmentViewController: UIViewController, FSCalendarDelegate,FSCalendarDataSource, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {

    var appoinmentItem : AppointmentModel?
    var appointmentTimeList = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        // Show the selected date on calender
        self.calendar.select(Date())
        
        // collectionView to adapt to the size of calender when expand and collaspe
        self.view.addGestureRecognizer(self.scopeGesture)
        self.collectionView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
         // For navigation bar
        self.title = "Update Appointment"
        self.navigationItem.rightBarButtonItem = nil;
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var data = ["9:00 AM - 10:00 AM", "10:00 AM - 11:00 AM", "11:00 AM - 12:00 PM", "12:00 PM - 1:00 PM", "1:00 PM - 2:00 PM","2:00 PM - 3:00 PM","3:00 PM - 4:00 PM","4:00 PM - 5:00 PM", "5:00 PM - 6:00 PM"]
    

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    // For calender dateformat
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    // For calender
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    
    deinit {
        print("\(#function)")
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    // Expand and collaspe
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.collectionView.contentOffset.y <= -self.collectionView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    //Calander
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // When calender date is selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
 
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        
        self.collectionView.reloadData();
        let SelectedDate = String(describing: self.calendar.selectedDate.map({self.dateFormatter.string(from: $0)})!)
        self.appointmentTimeList.removeAll()
        AppointmentDataManager().getTimeByDoctorDate((appoinmentItem?.doctorName)!, SelectedDate) { (Appointment) in
            self.appointmentTimeList.append(Appointment.time)
            self.collectionView.reloadData();
        }
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
    //collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CreateCollectionViewCell
        
        cell.time.text = data[indexPath.row]
        
        // If appointment for that time and date is available will remain green
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.backgroundColor = UIColor(hex: 0x2ECC71)
        
        // If appointment for that time and date is occupied will turn red
        appointmentTimeList.forEach { (element) in
            if element == data[indexPath.row]{
                cell.time.text = "Unavailable"
                cell.contentView.layer.cornerRadius = 10.0
                cell.contentView.layer.borderWidth = 1.0
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.masksToBounds = false
                cell.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
                cell.layer.shadowRadius = 4.0
                cell.layer.shadowOpacity = 1.0
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
                cell.backgroundColor = UIColor(hex: 0xD91E18)
                cell.isUserInteractionEnabled = false
            }
            
        }
        
        return cell
    }
    
    
    //pass selected date and time to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showUpdateAppointmentDetails") {
            let detailViewController = segue.destination as! showUpdateAppointmentDetailsViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            if(indexPath != nil) {
                
                let appointmentItem = data[(indexPath?.row)!]
                
                let appointment = AppointmentModel(
                    (appoinmentItem?.id)!,
                    (appoinmentItem?.nric)!,
                    (appoinmentItem?.doctorName)!,
                    String(describing: calendar.selectedDate.map({self.dateFormatter.string(from: $0)})!),
                    appointmentItem
                )
                
                detailViewController.appoinmentUpdateItem = appointment
                
            }
            
        }
    }
}
