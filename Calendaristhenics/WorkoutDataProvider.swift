//
//  WorkoutDataProvider.swift
//  Calendaristhenics
//
//  Created by Michael Gubik on 2018-08-08.
//  Copyright © 2018 Michael Gubik. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutDataProvider {
    class func loadWorkouts(completionHandler: @escaping (([Workout]?, Error?) -> Swift.Void)){
        let ascendingSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
                                  predicate: nil,
                                  limit: 0,
                                  sortDescriptors: [ascendingSortDescriptor],
                                  resultsHandler: { (query, samples, error) in
                                    guard let hkWorkouts = samples as? [HKWorkout], error == nil else {
                                        completionHandler(nil, error)
                                        return
                                    }
                                    let workouts = WorkoutDataProvider.processWorkouts(hkWorkouts)
                                    completionHandler(workouts, error)
                                    
        })
        HKHealthStore().execute(query)
    }
    
    class func processWorkouts(_ workouts: [HKWorkout]) -> [Workout] {
        return workouts.map { hkWorkout in
            let type = hkWorkout.workoutActivityType.description
            return Workout.init(type: type,
                                startDate: hkWorkout.startDate,
                                endDate: hkWorkout.endDate,
                                duration: hkWorkout.duration)
        }
    }
}
