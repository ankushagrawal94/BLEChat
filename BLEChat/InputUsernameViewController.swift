//
//  InputUsernameViewController.swift
//  BLEChat
//
//  Created by Ankush Agrawal on 10/4/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import UIKit

class InputUsernameViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var ourView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ourView.backgroundColor = UIColor(patternImage: UIImage(named: "app-blurred-bg-3.jpg")!)
        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let viewController:ViewController = segue.destinationViewController as ViewController
        
        viewController.username = username.text
        //segue.destinationViewController.username = username
    }

}