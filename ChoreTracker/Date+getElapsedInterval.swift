//
//  NSDate+getElapsedInterval.swift
//  ChoreTracker
//
//  Created by Seth Skocelas on 12/16/16.
//  Copyright © 2016 Seth Skocelas. All rights reserved.
//

import Foundation


//Source: http://stackoverflow.com/questions/34457434/swift-convert-time-to-time-ago
//Minor edits made to correct bug with months and days

extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else {
            return "a moment ago"
            
        }
        
    }
}
