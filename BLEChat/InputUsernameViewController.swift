//
//  InputUsernameViewController.swift
//  BLEChat
//
//  Created by Ankush Agrawal on 10/4/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import UIKit

class InputUsernameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    @IBOutlet var ourView: UIView!
    @IBOutlet weak var usernameTextView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        ourView.backgroundColor = UIColor(patternImage: UIImage(named: "background_home.png")!)
        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let viewController:UsersTableViewController = segue.destinationViewController as UsersTableViewController
        
        viewController.displayName = usernameTextView.text
        //segue.destinationViewController.username = username
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //pass the username over
        return true
    }
    
}