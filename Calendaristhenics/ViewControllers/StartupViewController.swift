//
//  StartupViewController.swift
//  Calendaristhenics
//
//  Created by Michael Gubik on 2018-08-08.
//  Copyright © 2018 Michael Gubik. All rights reserved.
//

import UIKit

class StartupViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delaysContentTouches = false
        tableView.contentInset.top = 20
    }

    @IBAction func authorizeCalendarAccess(_ sender: Any) {
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
            print("calendar")
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

}
