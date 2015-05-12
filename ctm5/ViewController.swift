//
//  ViewController.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var manager = IOSAppWatchManager.sharedInstance
    @IBOutlet weak var loginStatusLabel: UILabel!
    @IBOutlet weak var loginButtonLabel: UIButton!
    @IBAction func logInOutButtonPressed(sender: AnyObject) {
        if let sharedDefaults = NSUserDefaults(suiteName: self.manager.sharedStorageManager.appGroup) {
            if let loggedInUserServerId = sharedDefaults.objectForKey(self.manager.sharedStorageManager.sharedDefaultsLoggedInUserKey) as? String {
                self.manager.logInOutUser(nil)
            } else {
                self.manager.logInOutUser("Goober")
            }
            self.showLoginStatus()
        } else {
            println("Did not get sharedDefaults in WatchManager")
        }
    }
    func showLoginStatus() {
        if let sharedDefaults = NSUserDefaults(suiteName: self.manager.sharedStorageManager.appGroup) {
            if let loggedInUserServerId = sharedDefaults.objectForKey(self.manager.sharedStorageManager.sharedDefaultsLoggedInUserKey) as? String {
                self.loginStatusLabel.text = loggedInUserServerId
                self.loginButtonLabel.setTitle("Log Out", forState: UIControlState.Normal)
            } else {
                self.loginStatusLabel.text = "Not Logged In"
                self.loginButtonLabel.setTitle("Log In", forState: UIControlState.Normal)
            }
        } else {
            println("Did not get sharedDefaults in WatchManager")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated )
        showLoginStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

