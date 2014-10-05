//
//  UsersTableViewController.swift
//  BLEChat
//
//  Created by Ankush Agrawal on 10/5/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//


import UIKit

class UsersTableViewController: UITableViewController {
    var displayName: NSString?
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var username: NSString = UIDevice.currentDevice().name
    var usersArr: [String] = [String]()
    var mailButton = UIButton(frame: CGRectMake(225, 13, 20, 20))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //add a button on the top right and add the following action for it
        
        self.mailButton.setBackgroundImage(UIImage(named: "user.png"), forState: UIControlState.Normal)
        self.mailButton.addTarget(self, action: "connect", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(self.mailButton)
        
        
        // Uncomment the following line to preserve selection between presentations
        
        // self.clearsSelectionOnViewWillAppear = false
        
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func connect() {
        println("pushing view controller")
        self.navigationController?.pushViewController(ConnectionsViewController(), animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // #warning Potentially incomplete method implementation.
        
        // Return the number of sections.
        
        return 1
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete method implementation.
        
        // Return the number of rows in the section.
        
        return 5
        
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.row == 0 {
            
            cell.textLabel?.text = "Ankush"
            
        }
        
        if indexPath.row == 1 {
            
            cell.textLabel?.text = "Clayton"
            
        }
        
        if indexPath.row == 2 {
            
            cell.textLabel?.text = "Elle"
            
        }
        
        if indexPath.row == 3 {
            
            cell.textLabel?.text = "Long"
            
        }
        
        if indexPath.row == 4 {
            
            cell.textLabel?.text = "Rohan"
            
        }
        
        
        
        return cell
        
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var firstVC = FirstViewController()
        
        if indexPath.row == 0 {
            
            firstVC.username = "Ankush"
            
        }
        
        if indexPath.row == 1 {
            
            firstVC.username = "Clayton"
            
        }
        
        if indexPath.row == 2 {
            
            firstVC.username = "Elle"
            
        }
        
        if indexPath.row == 3 {
            
            firstVC.username = "Long"
            
        }
        
        if indexPath.row == 4 {
            
            firstVC.username = "Rohan"
            
        }
        
        
        
        var dict = Dictionary<String, UIImage>()
        
        dict["Ankush"] = UIImage(named: "kush.png")
        
        dict["Clayton"] = UIImage(named: "clayton.png")
        
        dict["Elle"] = UIImage(named: "elle.png")
        
        dict["Long"] = UIImage(named: "long.png")
        
        dict["Rohan"] = UIImage(named: "rohan.png")
        
        firstVC.avatars = dict
        
        
        
        self.navigationController?.pushViewController(firstVC, animated: true)
        
        
        
    }
    
    
    
    
    
    /*
    
    // Override to support conditional editing of the table view.
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    
    // Return NO if you do not want the specified item to be editable.
    
    return true
    
    }
    
    */
    
    
    
    /*
    
    // Override to support editing the table view.
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    if editingStyle == .Delete {
    
    // Delete the row from the data source
    
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    
    } else if editingStyle == .Insert {
    
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    
    }
    
    }
    
    */
    
    
    
    /*
    
    // Override to support rearranging the table view.
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    
    
    }
    
    */
    
    
    
    /*
    
    // Override to support conditional rearranging of the table view.
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    
    // Return NO if you do not want the item to be re-orderable.
    
    return true
    
    }
    
    */
    
    
    
    /*
    
    // MARK: - Navigation
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    // Get the new view controller using [segue destinationViewController].
    
    // Pass the selected object to the new view controller.
    
    }
    
    */
    
    
    
}

