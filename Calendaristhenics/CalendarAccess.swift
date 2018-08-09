//
//  CalendarAccess.swift
//  Calendaristhenics
//
//  Created by Michael Gubik on 2018-08-09.
//  Copyright © 2018 Michael Gubik. All rights reserved.
//

import Foundation
import EventKit

class CalendarAccess {
    class func requestEventStoreAccess() {
        EKEventStore().requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    //self.accessGranted = true
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //self.accessGranted = false
                })
            }
        })
    }
}
