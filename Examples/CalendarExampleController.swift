//
//  CalendarExampleController.swift
//  FSCalendarBootstrap
//
//  Created by Daniel on 2017-09-13.
//  Copyright © 2017 danielbogomazov. All rights reserved.
//

import UIKit

class CalendarExampleController: UIViewController {

    var calendar: CalendarView!
    var selectedDateLabel: UILabel!
    var dateFormatter: DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        // Setup calendar frame
        let width = view.frame.width / 3
        let height = view.frame.height / 3
        let calFrame: CGRect = CGRect(x: width, y: height, width: width, height: height)

        // Setup max/min calendar dates
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let minimumDate = dateFormatter.date(from: "January 01, 1900")
        let maximumDate = dateFormatter.date(from: "December 31, 2100")
        
        // Create calendar
        calendar = CalendarView(frame: calFrame, minimumDate: minimumDate, maximumDate: maximumDate)
        calendar.delegate = self
        
        view.addSubview(calendar.view)
        
        // Setup label frame
        let labelFrame: CGRect = CGRect(x: width, y: height * 2 + 20, width: width, height: 28)
        
        // Create label
        selectedDateLabel = UILabel(frame: labelFrame)
        
        // Setup label
        selectedDateLabel.backgroundColor = UIColor.white
        selectedDateLabel.isUserInteractionEnabled = false
        selectedDateLabel.textAlignment = .center
        
        // Setup initial date display
        selectedDateLabel.text = dateFormatter.string(from: calendar.selectedDate())

        view.addSubview(selectedDateLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}

extension CalendarExampleController: CalendarDelegate {
    
    // Calendar delegate methods
    func didSelect(date: Date) {
        selectedDateLabel.text = dateFormatter.string(from: date)
    }
}
