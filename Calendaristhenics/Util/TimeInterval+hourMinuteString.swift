//
//  TimeInterval+hourMinuteString.swift
//  Calendaristhenics
//
//  Created by Michael Gubik on 2018-08-08.
//  Copyright © 2018 Michael Gubik. All rights reserved.
//

import Foundation

extension TimeInterval {
    var hourMinuteString: String {
        let ti = Int(self)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.1d:%0.2d:%0.2d", hours, minutes, seconds)
    }
}
