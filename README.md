# FSCalendarBootstrap
Bootstrap of [WenchaoD's FSCalendar](https://github.com/WenchaoD/FSCalendar) framework.
FSCalendarBootstrap is an easy, out-of-the-box calendar class designed for iOS applications. It was designed to implement an option to change the calendar’s year.

### Selection
![1](https://raw.githubusercontent.com/danielbogomazov/FSCalendarBootstrap/master/Images/1.gif)

### Invalid Year Selection
![2](https://raw.githubusercontent.com/danielbogomazov/FSCalendarBootstrap/master/Images/2.gif)

### Traversal to Minimum Date
![3](https://raw.githubusercontent.com/danielbogomazov/FSCalendarBootstrap/master/Images/3.gif)

### Traversal to Maximum Date
![4](https://raw.githubusercontent.com/danielbogomazov/FSCalendarBootstrap/master/Images/4.gif)


## Getting Started 
Copy CalendarView.swift into your project directory. Extend classes that use CalendarView with **CalendarDelegate**.

### Prerequisites
You must include WenchaoD's FSCalendar files into your project. Please visit his github (linked above) to learn how.

**NOTE:** FSCalendarBootstrap uses the FSCalendar framework which is written in Objective-C. To get it to work with Swift projects, you must include a [bridging header](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html#//apple_ref/doc/uid/TP40014216-CH10-ID122)

### Installing
After you have successfully added FSCalendar and FSCalendarBootstrap and a bridging header to your project, follow the following steps:
* Extend your class with **CalendarDelegate**
* Create you calendar variable
* Initialize your CalendarView variable giving it a frame, minimum date, and maximum date
* Assign the calendar's delegate
* Subclass your CalendarView variable under your controller's view

To assign an action to a date being selected, implement `func didSelect(date: Date)`.
To change the maximum or minimum date *after* initialization, implement `func maximumDate() -> Date` or `func minimumDate() -> Date`. These functions should return the desired maximum or minimum date.

The calendar's appearance can be changed by changing the following variables:
* headerDateFormat
* scrollDirection
* allowsMultipleSelection
* firstWeekday
* weekdayTextColor
* headerTitleColor
* eventDefaultColor
* eventSelectionColor
* selectionColor
* todayColor
* todaySelectionColor
* yearTextColor
* titleTodayColor
* borderRadius
* calendarColor
* headerColor

### Examples
Please see the **Examples** folder for examples of how FSCalendarBootstrap can be used.

Any additional functionalities that are not currently implemented into the bootstrap can be found on WenchaoD's FSCalendar github page.

# License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

# Acknowledgment
Thank you to WenchaoD for the FSCalendar framework.
