//
//  StartupViewController.swift
//  Calendaristhenics
//
//  Created by Michael Gubik on 2018-08-08.
//  Copyright © 2018 Michael Gubik. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class StartupViewController: UITableViewController, EKCalendarChooserDelegate {
    
    var calendarAccess = false
    var healthKitAccess = false
    let eventStore = EKEventStore()
    var calendarChooser: EKCalendarChooser!
    @IBOutlet weak var calendarNameCell: CalendarNameCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delaysContentTouches = false
        tableView.contentInset.top = 20
        
        if calendarAccess && healthKitAccess {
            performSegue(withIdentifier: "showWorkoutsSegue", sender: self)
        }
    }

    @IBAction func authorizeCalendarAccess(_ sender: Any) {
        EKEventStore().requestAccess(to: EKEntityType.event) {
            (accessGranted: Bool, error: Error?) in
            self.calendarAccess = accessGranted
        }
    }
    
    @IBAction func authorizeHealthKitAccess(_ sender: Any) {
        HealthKitSetupAssistant.authorizeHealthKit { (granted, error) in
            guard granted == true else {
                print("Couldn't get HealthKit Access")
                return
            }
        }
        print("HealthKit Access granted")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            showCalendarChooser()
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

    
    func showCalendarChooser() {
        calendarChooser = EKCalendarChooser(selectionStyle: .single, displayStyle: .writableCalendarsOnly, entityType: .event, eventStore: eventStore)
        calendarChooser.showsDoneButton = false
        calendarChooser.showsCancelButton = false
        calendarChooser.navigationItem.title = "Select Calendar"
        calendarChooser.navigationItem.backBarButtonItem = nil
        calendarChooser.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelCalendarChooser(_:)))
        
        calendarChooser.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(startEditing))
        
        
//        if let location = location, let calendarIdentifier = location.calendarIdentifier {
//            if let selectedCalendar = eventStore.calendar(withIdentifier: calendarIdentifier) {
//                calendarChooser.selectedCalendars = [selectedCalendar]
//            }
//        }
        
        calendarChooser.delegate = self
        self.navigationController?.pushViewController(calendarChooser, animated: true)
    }
    
    @objc func cancelCalendarChooser(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }


    func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonAction() {
        performSegue(withIdentifier: "UnwindToLocationList", sender: self)
    }
    
    
    // MARK: - calendar chooser delegate methods
    
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        guard calendarChooser.selectedCalendars.first != nil else { return }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        guard calendarChooser.selectedCalendars.first != nil else { return }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func calendarChooserSelectionDidChange(_ calendarChooser: EKCalendarChooser) {
        if let calendar = calendarChooser.selectedCalendars.first {
            print(calendar.title)
            calendarNameCell.calendarLabel.text = calendar.title
            calendarNameCell.circleView.color = calendar.cgColor
            _ = self.navigationController?.popViewController(animated: true)
        }
    }



    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    @objc func startEditing() {
        calendarChooser.isEditing = true
        calendarChooser.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditing))
    }

    @objc func endEditing() {
        calendarChooser.isEditing = false
        calendarChooser.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(startEditing))
    }

}
