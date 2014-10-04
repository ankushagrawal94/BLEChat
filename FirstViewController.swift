//
//  FirstViewController.swift
//  BLEChat
//
//  Created by Ankush Agrawal on 10/4/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FirstViewController: UIViewController, ConnectionsViewControllerDelegate {

    var appDelegate: AppDelegate?
    var username: NSString?
    var usersArr: [String] = [String]()
    
    @IBOutlet var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(username)
        println("first vc did load")
        var button = UIButton(frame: CGRectMake(20, 20, 50, 30))
        button.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataWithNotification:", name: "MSDidReceiveDataWithNotification", object: nil)
        // Do any additional setup after loading the view.
    }
    
    func sendMyMessage() {
        var to: NSString = "A" //A, C, L, R
        var from: NSString = "R"
        var init_timestamp: NSString = getCurrDate()
        var num_bounces: NSInteger = 0
        var message: NSString = "This is the message"
        var path: NSArray = ["R"]
        var textMessage = NSDictionary(objects: [to, from, init_timestamp, num_bounces, message, path], forKeys: ["to", "from", "init_timestamp", "num_bounces", "message", "path"], count: 5)
        var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(textMessage)
        var allPeers = appDelegate?.mcManager?.session.connectedPeers
        var error: NSError?
        appDelegate?.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if((error) != nil){
            print(error?.localizedDescription)
        }
        print(allPeers)
    }
    
    func callSendEnter() {
        println("delegate method sendEnter called")
        sendEnter()
    }
    
    func sendEnter() {
        var username = self.username
        print (username)
        var dict = NSDictionary(objects: ["enter", username], forKeys: ["type", "username"], count: 2)
        var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(dict)
        var allPeers = appDelegate?.mcManager?.session.connectedPeers
        var error: NSError?
        appDelegate?.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if((error) != nil){
            print(error?.localizedDescription)
        }
        print(allPeers)
    }

    
    func didReceiveDataWithNotification(notification: NSNotification) {
        var peerID: MCPeerID = notification.userInfo?["peerID"]! as MCPeerID
        var peerDisplayName = peerID.displayName
        var receivedData = notification.userInfo?["data"] as NSData
        var receivedDict: NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(receivedData) as NSDictionary
        var type = receivedDict["type"] as NSString
        if(type == "message"){
            var temp = textLabel.text! + peerDisplayName + " wrote: " + (receivedDict["message"] as NSString)
            print(peerDisplayName + " wrote: " + (receivedDict["message"] as NSString) + "\n")
            
            //Determine if we want to trasmit this to other phones
            if ((receivedDict["from"] as String) != "R"){
                sendMyMessage()
            }else {
                textLabel.text = temp
            }
        }
        else if (type == "enter"){
            print(receivedDict["username"] as NSString)
            print(usersArr)
            if !contains(usersArr, receivedDict["username"] as NSString) {
                usersArr.append(receivedDict["username"] as NSString)
                print(usersArr)
            }
        }
        
        
        
    }

    @IBAction func tap(sender: AnyObject) {
        //sendMyMessage()
        sendEnter()
    }
    
    func getCurrDate() -> String {
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
    }
}
