//
//  CalendarView.swift
//  FSCalendarBootstrap
//
//  Created by Daniel on 2017-09-07.
//  Copyright © 2017 danielbogomazov. All rights reserved.
//

import UIKit

// TODO : Get rid of the CalendarTextColor Protocol things and add { get, set } to the color vars in the class itself

@objc protocol CalendarDelegate {
    @objc optional func didSelect(date: Date)
    @objc optional func maximumDate() -> Date
    @objc optional func minimumDate() -> Date
}

class CalendarView: UIView, FSCalendarDataSource {
    
    /* Views */
    var view: UIView!
    fileprivate var topPadding: UIView!
    fileprivate var calendar: FSCalendar!
    fileprivate var yearTextField: UITextField!
    
    /* FSCalendar Variables */
    var headerDateFormat: String = "MMMM" {
        didSet {
            self.calendar.appearance.headerDateFormat = headerDateFormat
        }
    }
    var scrollDirection: FSCalendarScrollDirection = .horizontal {
        didSet {
            self.calendar.scrollDirection = scrollDirection
        }
    }
    var allowsMultipleSelection: Bool = false {
        didSet {
            self.calendar.allowsMultipleSelection = allowsMultipleSelection
        }
    }
    var firstWeekday: UInt = 1 {
        didSet {
            self.calendar.firstWeekday = firstWeekday
        }
    }
    
    var weekdayTextColor: UIColor = UIColor.black {
        didSet {
            self.calendar.appearance.weekdayTextColor = weekdayTextColor
        }
    }
    var headerTitleColor: UIColor = UIColor.white {
        didSet {
            self.calendar.appearance.headerTitleColor = headerTitleColor
        }
    }
    var eventDefaultColor: UIColor = UIColor.clear {
        didSet {
            self.calendar.appearance.eventDefaultColor = eventDefaultColor
        }
    }
    var eventSelectionColor: UIColor = UIColor.clear {
        didSet {
            self.calendar.appearance.eventSelectionColor = eventSelectionColor
        }
    }
    var selectionColor: UIColor = UIColor(red: 220/255, green: 95/255, blue: 70/255, alpha: 1.0) {
        didSet {
            self.calendar.appearance.selectionColor = selectionColor
        }
    }
    var todayColor: UIColor = UIColor.white {
        didSet {
            self.calendar.appearance.todayColor = todayColor
        }
    }
    var todaySelectionColor: UIColor = UIColor(red: 220/255, green: 95/255, blue: 70/255, alpha: 1.0) {
        didSet {
            self.calendar.appearance.todaySelectionColor = todaySelectionColor
        }
    }
    var yearTextColor: UIColor = UIColor.white.withAlphaComponent(0.5) {
        didSet {
            self.yearTextField.textColor = yearTextColor
        }
    }
    var titleTodayColor: UIColor = UIColor(red: 220/255, green: 95/255, blue: 70/255, alpha: 1.0) {
        didSet {
            self.calendar.appearance.titleTodayColor = titleTodayColor
        }
    }
    var borderRadius: CGFloat = 1 {
        didSet {
            self.calendar.appearance.borderRadius = borderRadius
        }
    }
    
    /* Additional Calendar Variables */
    var calendarColor: UIColor = UIColor.white {
        didSet {
            self.calendar.backgroundColor = calendarColor
        }
    }
    var headerColor: UIColor = UIColor(red: 220/255, green: 95/255, blue: 70/255, alpha: 1.0) {
        didSet {
            self.calendar.calendarHeaderView.backgroundColor = headerColor
            self.view.backgroundColor = headerColor
        }
    }


    
    /* Functionalities/Parameters */
    fileprivate var minimumDate: Date!
    fileprivate var maximumDate: Date!
    fileprivate var dateFormatter: DateFormatter!
    
    /* Misc. */
    var delegate: CalendarDelegate? {
        didSet {
            calendar.reloadData()
            selectDefaultDate()
        }
    }
    
    /* Constants */
    fileprivate let kMaxYearCharactersCount: Int = 4
    
    init(frame: CGRect, minimumDate: Date!, maximumDate: Date!) {
        super.init(frame: frame)
        
        /* Initialize Variables */
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.dateFormatter = DateFormatter()
        
        /* Build Calendar View */
        let viewWidth = frame.width
        let viewHeight = frame.height
        let topPaddingHeight: CGFloat = 15.0
        let yearLabelHeight: CGFloat = 20.0
        let calendarHeight = viewHeight - topPaddingHeight
        
        self.view = UIView(frame: frame)
        
        self.calendar = FSCalendar(frame: CGRect(x: 0, y: topPaddingHeight, width: viewWidth, height: calendarHeight))
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0
        self.calendar.clipsToBounds = true
        selectDefaultDate()
        self.view.addSubview(self.calendar)
        
        self.topPadding = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: topPaddingHeight))
        self.view.addSubview(self.topPadding)
        
        self.dateFormatter.dateFormat = "yyyy"
        self.yearTextField = UITextField(frame: CGRect(x: viewWidth / 3, y: topPaddingHeight / 2, width: viewWidth / 3, height: yearLabelHeight))
        self.yearTextField.textAlignment = .center
        self.yearTextField.text = self.dateFormatter.string(from: Date())
        self.yearTextField.delegate = self
        self.view.addSubview(self.yearTextField)

        /* Change Initial Colors */
        initializeAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Textfield Delegate Functions */
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != self.yearTextField {
            return true
        }
        
        let newSubjectString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let newCharacters = CharacterSet(charactersIn: newSubjectString as String)
        
        if !CharacterSet.decimalDigits.isSuperset(of: newCharacters) {
            /* New characters are not numeric characters */
            return false
        } else if newSubjectString.count > 4 {
            /* Year field too long - should only be 4 characters */
            return false
        } else if newSubjectString.count == self.kMaxYearCharactersCount {
            /* Checks if the year is valid */
            textField.text = newSubjectString
            self.view.endEditing(true)
            return shouldDisplayYear()
        } else {
            return true
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField != self.yearTextField {
            return true
        }
        
        let _ = shouldDisplayYear()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != self.yearTextField {
            return true
        }
        
        self.view.endEditing(true)
        return true
    }
    
    ////////////////////////////// PRIVATE //////////////////////////////
    
    /* Initializes all colors and formats */
    fileprivate func initializeAppearance() {
        self.calendar.appearance.headerDateFormat = headerDateFormat
        self.calendar.scrollDirection = scrollDirection
        self.calendar.allowsMultipleSelection = allowsMultipleSelection
        self.calendar.firstWeekday = firstWeekday
        self.calendar.appearance.weekdayTextColor = weekdayTextColor
        self.calendar.appearance.headerTitleColor = headerTitleColor
        self.calendar.appearance.eventDefaultColor = eventDefaultColor
        self.calendar.appearance.eventSelectionColor = eventSelectionColor
        self.calendar.appearance.selectionColor = selectionColor
        self.calendar.appearance.todayColor = todayColor
        self.calendar.appearance.todaySelectionColor = todaySelectionColor
        self.yearTextField.textColor = yearTextColor
        self.calendar.appearance.titleTodayColor = titleTodayColor
        self.calendar.appearance.borderRadius = borderRadius
        self.calendar.backgroundColor = calendarColor
        self.calendar.calendarHeaderView.backgroundColor = headerColor
        self.view.backgroundColor = headerColor
    }
    
    /* Checks if yearTextField's text is a valid year
     * If it is, calendar will automatically transition to that year
     * If it is not, it will trigger the textField to shake and will not change the calendar's year */
    fileprivate func shouldDisplayYear() -> Bool {
        self.dateFormatter.dateFormat = "yyyy"
        let pageYear = dateFormatter.string(from: self.calendar.currentPage)
        let maxYear = dateFormatter.string(from: self.maximumDate)
        let minYear = dateFormatter.string(from: self.minimumDate)
        self.dateFormatter.dateFormat = "MM"
        let pageMonth = dateFormatter.string(from: self.calendar.currentPage)
        
        /* Year must be 'kMaxYearCharactersCount' characters long */
        if self.yearTextField.text?.count != self.kMaxYearCharactersCount {
            shakeTextFieldAnimation(textField: self.yearTextField)
            self.yearTextField.text = pageYear
            return false
        }
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate: Date! = self.dateFormatter.date(from: "\(self.yearTextField.text!)-\(pageMonth)-01")
        
        /* Check if the newDate is within maximumDate/minimumDate
         * Set the page accordingly
         * If the newDate is not whithing the maximumDate/minimumDate, shake the textField and return false */
        if newDate <= self.maximumDate && newDate >= self.minimumDate {
            self.calendar.setCurrentPage(newDate, animated: true)
        } else if newDate > self.maximumDate && self.yearTextField.text == maxYear {
            self.calendar.setCurrentPage(self.maximumDate, animated: true)
        } else if newDate < self.minimumDate && yearTextField.text == minYear {
            self.calendar.setCurrentPage(self.minimumDate, animated: true)
        } else {
            shakeTextFieldAnimation(textField: yearTextField)
            yearTextField.text = pageYear
            return false
        }
        
        return true
    }
    
    /* TextField Animation */
    fileprivate func shakeTextFieldAnimation(textField: UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
    }
    
    ////////////////////////////// PUBLIC //////////////////////////////
    
    func selectDefaultDate() {
        let currentDate = Date()
        if currentDate > self.minimumDate && currentDate < self.maximumDate {
            self.calendar.select(currentDate)
        } else {
            self.calendar.select(self.maximumDate)
        }
    }
    
    func selectDate(date: Date) {
        calendar.select(date)
    }

    func selectedDate() -> Date {
        return self.calendar.selectedDate!
    }
}

extension CalendarView: UITextFieldDelegate {
    private func checkTextInputLimit(_ string: String, limit: Int, charSet: CharacterSet, allowAlpha: Bool) -> Bool {
        if !allowAlpha {
            if !CharacterSet.decimalDigits.isSuperset(of: charSet) {
                return false
            }
        }
        if string.count > limit {
            return false
        }
        return true
    }
}

extension CalendarView: FSCalendarDelegate {
    
    /* FSCalendar Delegate Functions */
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let _ = delegate {
            delegate!.didSelect?(date: date)
        }
    }
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        // This function is run multiple times when the calendar transitions (for every day of the month)
        // If you display Jan. 2017, the page will also display some dates from Dec. 2016 which can cause the logic to print "2016" instead of "2017"
        // depending on the last cell that this function calls
        // Because of this, we have to check for a date somewhere in the middle of the month to pull the page's year
        // We force the year to only change when this function hits the 20th day cell of the page to guarantee the correct year to be printed
        self.dateFormatter.dateFormat = "dd"
        if self.dateFormatter.string(from: date) == "20" {
            self.dateFormatter.dateFormat = "yyyy"
            self.yearTextField.text = dateFormatter.string(from: date)
        }
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        if let date = delegate?.maximumDate?() {
            self.maximumDate = date
            return date
        }
        return self.maximumDate
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        if let date = delegate?.minimumDate?() {
            self.minimumDate = date
            return date
        }
        return self.minimumDate
    }
}
