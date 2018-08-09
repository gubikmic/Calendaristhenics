//
//  WorkoutsTableViewController.swift
//  Calendaristhenics
//
//  Created by Michael Gubik on 2018-08-08.
//  Copyright © 2018 Michael Gubik. All rights reserved.
//

import UIKit
import EventKit

class WorkoutsTableViewController: UITableViewController {

    var workouts = [Workout]()
    var staticCellAtTheTop: UITableViewCell?
    var calendarIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delaysContentTouches = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WorkoutDataProvider.loadWorkouts { (workouts, error) in
            guard let workouts = workouts, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.workouts = workouts.reversed()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if staticCellAtTheTop == nil {
                staticCellAtTheTop = tableView.dequeueReusableCell(withIdentifier: "staticCellAtTheTop", for: indexPath)
            }
            return staticCellAtTheTop!
        } else {
            let workoutCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutCell
            workoutCell.button.removeTarget(nil, action: nil, for: .allEvents)
            workoutCell.button.addTarget(self, action: #selector(cellButtonAction(_:)), for: .touchUpInside)
            let workout = workouts[indexPath.row]
            workoutCell.mainLabel.text = "\(workout.type) \(workout.duration.hourMinuteString)"
            workoutCell.dateLabel.text = workout.dateString
            
            // set button depending on whether a calendar event already exists or not
            
            
            return workoutCell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 85
        } else {
            return 64
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func cellButtonAction(_ sender: Any) {
        guard let sender = sender as? UIButton,
            let cell = sender.superview?.superview as? WorkoutCell else { return }
        let indexPath = tableView.indexPath(for: cell)!
        let workout = workouts[indexPath.row]
        
        print("creating Calendar event for workout \(workout)")
        
        // TODO: check if this workout is already present in the calendar
        
        let eventStore = EKEventStore()
        guard let calendarIdentifier = calendarIdentifier,
            let calendar = eventStore.calendar(withIdentifier: calendarIdentifier) else { return }
        let event = EKEvent(eventStore: eventStore)
        event.title = workout.type
        event.startDate = workout.startDate
        event.endDate = workout.endDate
        event.notes = "Generated by Calendaristhenics"
        event.calendar = calendar
        try! eventStore.save(event, span: .thisEvent, commit: true)
    }

}
