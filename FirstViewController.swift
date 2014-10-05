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

    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var username: NSString = UIDevice.currentDevice().name
    var usersArr: [String] = [String]()
    
    @IBOutlet var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(username)
        println("first vc did load")
        var button = UIButton(frame: CGRectMake(20, 20, 50, 30))
        button.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        //appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataWithNotification:", name: "MSDidReceiveDataWithNotification", object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func sendMyMessage() {
        var type: NSString = "message"
        var to: NSString = ""
        var from: NSString = UIDevice.currentDevice().name
        println("from: " + from)
        var init_timestamp: NSString = getCurrDate()
        var num_bounces: NSInteger = 0
        var message: NSString = "This is the brand new message!!!"
        var path: NSArray = ["R"]
        var textMessage = NSDictionary(objects: [type, to, from, init_timestamp, num_bounces, message, path], forKeys: ["type", "to", "from", "init_timestamp", "num_bounces", "message", "path"], count: 7)
        var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(textMessage)
        var allPeers = appDelegate.mcManager?.session.connectedPeers
        var error: NSError?
        appDelegate.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
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
        var type = "enter"
        var path = NSArray(object: username)
        var dict = NSDictionary(objects: [type, username, path], forKeys: ["type", "username", "path"], count: 3)
        var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(dict)
        var allPeers = appDelegate.mcManager!.session.connectedPeers
        println(appDelegate.mcManager!.session.connectedPeers.count)
        //println(appDelegate!.mcManager!.session.connectedPeers.count)
        var error: NSError?
        appDelegate.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if((error) != nil){
            print(error?.localizedDescription)
        }
        //print("all peers is: ")
        //print(allPeers)
    }

    func didReceiveDataWithNotification(notification: NSNotification) {
        var peerID: MCPeerID = notification.userInfo?["peerID"]! as MCPeerID
        var peerDisplayName = peerID.displayName as String
        var receivedData = notification.userInfo?["data"] as NSData
        var receivedDict: NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(receivedData) as NSDictionary
        var type = receivedDict["type"] as NSString
        if(type == "message"){
            var temp = textLabel.text! + peerDisplayName + " wrote: " + (receivedDict["message"] as NSString)
            print(peerDisplayName + " wrote: " + (receivedDict["message"] as NSString) + "\n")
            
            println(receivedDict["from"])
            println(peerDisplayName)
            //Determine if we want to trasmit this to other phones
            if ((receivedDict["to"] as String) != UIDevice.currentDevice().name){
                sendMyMessage()
                println("first case")
            }else {
                textLabel.text = temp
                println("second case")
            }
        }
        else if (type == "enter"){
            //print(receivedDict["username"] as NSString)
            //print(usersArr)
            if !contains(usersArr, receivedDict["username"] as NSString) {
                usersArr.append(receivedDict["username"] as NSString)
                //print(usersArr)
                
                //Send back to OP
                var type = "acq_lib"
                var target = receivedDict["username"] as NSString
                var dict = NSDictionary(objects: [type, ], forKeys: ["type", "target"], count: 2)
                var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(dict)
                var allPeers = appDelegate.mcManager?.session.connectedPeers
                var error: NSError?
                appDelegate.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
                if((error) != nil){
                    print(error?.localizedDescription)
                }
                
                //Send out to network
                var type2 = "enter"
                var path2 = receivedDict["path"] as NSArray
                var path3 = NSMutableArray(array: path2)
                path3.addObject(username)
                var dict2 = NSDictionary(objects: [type, username,path3], forKeys: ["type", "username", "path"], count: 3)
                var dataToSend2: NSData = NSKeyedArchiver.archivedDataWithRootObject(dict)
                var doReBroadcast = false
                for seenUser in path2{
                    let count: Int? = appDelegate.mcManager?.session.connectedPeers.count as Int?
                    for x in 0...count! {
                        if ((appDelegate.mcManager?.session.connectedPeers[x] as MCPeerID) == seenUser as MCPeerID) {
                            //the person has not already received the object
                            continue
                        }
                        else {
                            //we have to rebroadcast
                            doReBroadcast = true
                        }
                    }
                }
                if doReBroadcast{
                    var allPeers2 = appDelegate.mcManager?.session.connectedPeers
                    var error2: NSError?
                    appDelegate.mcManager?.session.sendData(dataToSend2, toPeers: allPeers2, withMode: MCSessionSendDataMode.Reliable, error: &error2)
                    
                    if((error2) != nil){
                        print(error?.localizedDescription)
                    }
                }
            }
        }
        else if (type == "acq_lib") {
            if(username == (receivedDict["target"] as NSString)){
                //You are the OP
                usersArr = (receivedDict["usersArr"] as [String])
                println(usersArr)
            }
        }
    }

    @IBAction func tap(sender: AnyObject) {
        sendMyMessage()
        //sendEnter()
    }
    
    func getCurrDate() -> String {
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
    }
}
