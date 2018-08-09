//
//  Workout.swift
//  Calendaristhenics
//
//  Created by Michael Gubik on 2018-08-08.
//  Copyright © 2018 Michael Gubik. All rights reserved.
//

import Foundation

struct Workout {
    var type: String
    var startDate: Date
    var endDate: Date
    var duration: TimeInterval
}

extension Workout {
    var dateString: String {
        let calendar = Calendar.current
        let startDay = calendar.component(.day, from: startDate)
        let endDay = calendar.component(.day, from: endDate)
        
        if startDay == endDay {
            
        }
        return "\(Workout.dateFormatter.string(from: startDate)) - \(Workout.dateFormatter.string(from: endDate))"
    }
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}
