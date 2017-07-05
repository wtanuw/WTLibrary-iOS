//
//  WTDate.swift
//  Kamakko
//
//  Created by iMac on 4/5/16.
//  Copyright © 2016 iMac. All rights reserved.
//

import Foundation

import AFDateHelper

public extension Foundation.Date {
    
    // MARK: Components
    fileprivate static func componentFlags() -> NSCalendar.Unit { return [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.weekOfYear] }
    
    fileprivate static func components(fromDate: Foundation.Date) -> DateComponents! {
        return (Calendar.current as NSCalendar).components(Foundation.Date.componentFlags(), from: fromDate)
    }
    
    fileprivate func components() -> DateComponents  {
        return Foundation.Date.components(fromDate: self)!
    }
    
    
    // MARK: Comparing Dates
    
    /**
    Returns true if dates are equal while ignoring time.
    
    - Parameter date: The Date to compare.
    */
    func isSameDateIgnoringTime(_ date: Foundation.Date) -> Bool
    {
        let comp1 = Foundation.Date.components(fromDate: self)
        let comp2 = Foundation.Date.components(fromDate: date)
        return ((comp1!.year == comp2!.year) && (comp1!.month == comp2!.month) && (comp1!.day == comp2!.day))
    }
    
    func isSameOrEarlierThanDate(_ date: Foundation.Date) -> Bool
    {
        return self.isSameDateIgnoringTime(date) || (self as NSDate).earlierDate(date) == self
    }
    
    func isSameOrLaterThanDate(_ date: Foundation.Date) -> Bool
    {
        return self.isSameDateIgnoringTime(date) || (self as NSDate).laterDate(date) == self
    }
    
    
    // MARK: Adjusting Dates
    
    func dateByAddingMonths(_ months: Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.month = months
        let retDate = (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
        if self.component(.day) == retDate.component(.day) {
            return retDate
        }
        return retDate.dateAtTheEndOfMonth(retDate.component(.month)!-1)
        
    }
    
    func dateBySubtractingMonths(_ months: Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.month = (months * -1)
        let retDate = (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
        if self.component(.day) == retDate.component(.day) {
            return retDate
        }
        return retDate.dateAtTheEndOfMonth(retDate.component(.month)!-1)
    }
    
    func dateByAddingYears(_ years: Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.year = years
        return (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func dateBySubtractingYears(_ years: Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.year = (years * -1)
        return (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func dateByAddingDaysAndMonths(days:Int, months:Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.month = months
        dateComp.day = days
        return (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func dateBySubtractingDaysAndMonths(days:Int, months:Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.month = (months * -1)
        dateComp.day = (days * -1)
        return (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func dateByAddingMonthsAndYears(months:Int, years: Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.month = months
        dateComp.year = years
        let retDate = (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
        if self.component(.day) == retDate.component(.day) {
            return retDate
        }
        return retDate.dateAtTheEndOfMonth(retDate.component(.month)!-1)
    }
    
    func dateBySubtractingMonthsAndYears(months:Int, years: Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.month = (months * -1)
        dateComp.year = (years * -1)
        let retDate = (Calendar.current as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
        if self.components().day == retDate.component(.day) {
            return retDate
        }
        return retDate.dateAtTheEndOfMonth(retDate.component(.month)!-1)
    }
    
//    /**
//     Creates a new date from the start of the day.
//     
//     - Returns A new date object.
//     */
//    func dateAtStartOfDay() -> NSDate
//    {
//        let components = self.components()
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
//        return NSCalendar.currentCalendar().dateFromComponents(components)!
//    }
//    
//    /**
//     Creates a new date from the end of the day.
//     
//     - Returns A new date object.
//     */
//    func dateAtEndOfDay() -> NSDate
//    {
//        let components = self.components()
//        components.hour = 23
//        components.minute = 59
//        components.second = 59
//        return NSCalendar.currentCalendar().dateFromComponents(components)!
//    }
//    
//    /**
//     Creates a new date from the start of the week.
//     
//     - Returns A new date object.
//     */
//    func dateAtStartOfWeek() -> NSDate
//    {
//        let flags :NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday]
//        let components = NSCalendar.currentCalendar().components(flags, fromDate: self)
//        components.weekday = NSCalendar.currentCalendar().firstWeekday
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
//        return NSCalendar.currentCalendar().dateFromComponents(components)!
//    }
//    
//    /**
//     Creates a new date from the end of the week.
//     
//     - Returns A new date object.
//     */
//    func dateAtEndOfWeek() -> NSDate
//    {
//        let flags :NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Weekday]
//        let components = NSCalendar.currentCalendar().components(flags, fromDate: self)
//        components.weekday = NSCalendar.currentCalendar().firstWeekday + 6
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
//        return NSCalendar.currentCalendar().dateFromComponents(components)!
//    }
    
    /**
     Creates a new date from the first day of the month
     
     - Returns A new date object.
     */
    func dateAtTheStartOfMonth(_ month: Int) -> Foundation.Date
    {
        //Create the date components
        var components = self.components()
        components.month = month
        components.day = 1
        //Builds the first day of the month
        let firstDayOfMonthDate :Foundation.Date = Calendar.current.date(from: components)!
        
        return firstDayOfMonthDate
        
    }
    
    /**
     Creates a new date from the last day of the month
     
     - Returns A new date object.
     */
    func dateAtTheEndOfMonth(_ month: Int) -> Foundation.Date {
        
        //Create the date components
        var components = self.components()
        //Set the last day of this month
        components.month = month+1
        components.day = 0
        
        //Builds the first day of the month
        let lastDayOfMonth :Foundation.Date = Calendar.current.date(from: components)!
        
        return lastDayOfMonth
        
    }
    
    func dateAtTheDayOfMonth(day: Int, month:Int) -> Foundation.Date
    {
        //Create the date components
        var components = self.components()
        //Set the last day of this month
        components.month = month
        components.day = day
        
        //Builds the first day of the month
        let dayOfMonth :Foundation.Date = Calendar.current.date(from: components)!
        
        return dayOfMonth
        
    }
    
    // MARK: - deprecated
    private func minuteInSeconds() -> Double { return 60 }
    private func hourInSeconds() -> Double { return 3600 }
    private func dayInSeconds() -> Double { return 86400 }
    private func weekInSeconds() -> Double { return 604800 }
    private func yearInSeconds() -> Double { return 31556926 }
    
    func isEarlierThanDate(_ date:Foundation.Date) -> Bool
    {
//        return self.earlierDate(date) == self
        return self < date
    }
    
    func isLaterThanDate(_ date:Foundation.Date) -> Bool
    {
//        return self.laterDate(date) == self
        return self > date
    }
    
    func isInPast() -> Bool
    {
        return self.isEarlierThanDate(Foundation.Date())
    }
    
    func isInFuture() -> Bool
    {
        return self.isLaterThanDate(Foundation.Date())
    }
    
    func isEqualToDateIgnoringTime(_ date:Foundation.Date) -> Bool
    {
        let comp1 = Foundation.Date.components(fromDate: self)!
        let comp2 = Foundation.Date.components(fromDate: date)!
        return ((comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day))
    }
    
    func isToday() -> Bool
    {
        return self.isEqualToDateIgnoringTime(Foundation.Date())
    }
    
    func dateByAddingDays(_ days:Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.day = days
        return NSCalendar.current.date(byAdding: dateComp, to: self)!
    }
    
    func dateBySubtractingDays(_ days:Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.day = (days * -1)
        return NSCalendar.current.date(byAdding: dateComp, to: self)!
    }
    
    func dateByAddingHours(_ hours:Int) -> Foundation.Date
    {
        var dateComp = DateComponents()
        dateComp.hour = hours
        return NSCalendar.current.date(byAdding: dateComp, to: self)!
    }
    
    func dateAtStartOfDay() -> Foundation.Date
    {
        var components = self.components()
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSCalendar.current.date(from: components)!
    }
    
    func dateAtTheEndOfMonth() -> Foundation.Date
    {
        
        //Create the date components
        var components = self.components()
        //Set the last day of this month
        components.month = components.month!+1
        components.day = 0
        
        //Builds the first day of the month
        let lastDayOfMonth :Foundation.Date = NSCalendar.current.date(from: components)!
        
        return lastDayOfMonth
    }
    
    func daysBeforeDate(_ date:Foundation.Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / dayInSeconds())
    }
    
}
