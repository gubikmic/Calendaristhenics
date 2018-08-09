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
    var calendarIdentifier: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delaysContentTouches = false
        tableView.contentInset.top = 20
        
        calendarAccess = UserDefaults.standard.bool(forKey: "calendarAccess")
        healthKitAccess = UserDefaults.standard.bool(forKey: "healthKitAccess")
        
        if let calendarIdentifier = UserDefaults.standard.value(forKey: "calendarIdentifier") as? String {
            self.calendarIdentifier = calendarIdentifier
        }
        if calendarAccess && healthKitAccess == true {
            performSegue(withIdentifier: "showWorkoutsSegue", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let calendarIdentifier = calendarIdentifier,
            let calendar = eventStore.calendar(withIdentifier: calendarIdentifier)
        {
            calendarNameCell.calendarLabel.text = calendar.title
            calendarNameCell.circleView.color = calendar.cgColor
        }
    }

    @IBAction func authorizeCalendarAccess(_ sender: Any) {
        EKEventStore().requestAccess(to: EKEntityType.event) {
            (accessGranted: Bool, error: Error?) in
            self.calendarAccess = accessGranted
            UserDefaults.standard.setValue(accessGranted, forKey: "calendarAccess")
            print("Calendar Access granted")
        }
    }
    
    @IBAction func authorizeHealthKitAccess(_ sender: Any) {
        HealthKitSetupAssistant.authorizeHealthKit { (granted, error) in
            guard granted == true else {
                print("Couldn't get HealthKit Access")
                return
            }
        }
        healthKitAccess = true
        UserDefaults.standard.setValue(true, forKey: "healthKitAccess")
        print("HealthKit Access granted")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            showCalendarChooser()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let workoutsTableViewController = segue.destination as? WorkoutsTableViewController else { return }
        workoutsTableViewController.calendarIdentifier = calendarIdentifier
    }

    
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
            calendarIdentifier = calendar.calendarIdentifier
            calendarNameCell.calendarLabel.text = calendar.title
            calendarNameCell.circleView.color = calendar.cgColor
            UserDefaults.standard.setValue(calendarIdentifier, forKey: "calendarIdentifier")
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
