//
//  CreateAppointmentViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 30/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import FSCalendar;

class CreateAppointmentViewController: UIViewController, FSCalendarDelegate,FSCalendarDataSource, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {

    
    var data = ["9:00 am - 10:00 am", "10:00 am - 11:00 am", "11:00 am - 12:00 pm", "12:00 pm - 01:00 pm", "01:00 pm - 02:00 pm","02:00 pm - 03:00 pm (Break)","04:00 pm - 05:00 pm", "05:00 pm - 06:00 pm"]
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    
     var doctorName: String = ""
     var appointmentDateList: Array = [String] ()
     var appointmentTimeList = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        self.title = "Create Appointment"
        self.navigationItem.rightBarButtonItem = nil;
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // For calender dateformat
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
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
    
    // Calener
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // When calender date is selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        self.collectionView.reloadData();
        let SelectedDate = String(describing: self.calendar.selectedDate.map({self.dateFormatter.string(from: $0)})!)
        self.appointmentTimeList.removeAll()
        AppointmentDataManager().getTimeByDoctorDate(doctorName, SelectedDate) { (Appointment) in
            print("time booked \(Appointment.time)")
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
 
       // If appointment for that time and date is available will remain green
        cell.time.text = data[indexPath.row]
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
            }
            
        }
       return cell
    }

    //pass selected date and time to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showAppointmentDetails") {
            let detailViewController = segue.destination as! showAppointmentDetailsViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            print("Item2 \(indexPath!)")
            if(indexPath != nil) {
                
               let patientNric:String = "S9822477G"
                
                let appointmentItem = self.data[(indexPath?.row)!]
                let appointment = AppointmentModel(
                     "",
                    patientNric,
                    doctorName,
                    String(describing: self.calendar.selectedDate.map({self.dateFormatter.string(from: $0)})!),
                    appointmentItem
                )
                
                detailViewController.appoinmentItem = appointment

                
             }

            }
        }

    }
 



