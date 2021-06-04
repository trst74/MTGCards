//
//  NotificationsViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 12/4/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {
    
    var pageOne: PageOneViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func notifications(_ sender: Any) {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    @IBAction func done(_ sender: Any) {
        
                self.dismiss(animated: true)
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
