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
    
    @IBAction func sendText(sender: AnyObject) {
        sendMyMessage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(username)
        println("first vc did load")
        var button = UIButton(frame: CGRectMake(20, 20, 50, 30))
        button.addTarget(self, action: "sendText:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        //appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataWithNotification:", name: "MSDidReceiveDataWithNotification", object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func sendMyMessage() {
        var type: NSString = "message"
        var recipient: NSString = ""
        var sender: NSString = UIDevice.currentDevice().name
        var num_bounces: Int = 0
        var messageText: String = "This is the brand new message!!!"
        var path: NSArray = ["R"]
        
        var message = BLEMessage(type: type, sender: sender, recipient: recipient, text: messageText, numBounces: num_bounces, path: path)
        
        var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(message)
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
        var message = BLEMessage(type: type, sender: username)
        
        var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(message)
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
        
        var receivedMessage: BLEMessage = NSKeyedUnarchiver.unarchiveObjectWithData(receivedData) as BLEMessage
        
        var type = receivedMessage.type()
        
        if (type == "message") {
            var temp = textLabel.text! + peerDisplayName + " wrote: " + receivedMessage.text()
            print(peerDisplayName + " wrote: " + receivedMessage.text() + "\n")
            
            //println(receivedDict["from"])
            //println(peerDisplayName)
            //Determine if we want to trasmit this to other phones
            
            if (receivedMessage.recipient() != UIDevice.currentDevice().name) {
                sendMyMessage()
                println("first case")
            } else {
                textLabel.text = temp
                println("second case")
            }
        }
            
        else if (type == "enter") {
            //print(receivedDict["username"] as NSString)
            //print(usersArr)
            
            if !contains(usersArr, receivedMessage.sender()) {
                
                usersArr.append(receivedMessage.sender())
                //print(usersArr)
                
                //Send back to OP (person entering)
                var type = "acq_lib"
                var target = receivedMessage.sender()
                
                var message = BLEMessage(type: type, sender: username, recipient: target)
                var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(message)
                var allPeers = appDelegate.mcManager?.session.connectedPeers
                var error: NSError?
                appDelegate.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
                if (error != nil) {
                    print(error?.localizedDescription)
                }
                
                //Send out to network
                var type2 = "enter"
                var path2 = receivedMessage.path() as NSArray
                var path3 = NSMutableArray(array: path2)
                path3.addObject(username)
                
                var message2 = BLEMessage(type: type, sender: username, path: path3)
                
                var dataToSend2: NSData = NSKeyedArchiver.archivedDataWithRootObject(message2)
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
                if doReBroadcast {
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
            if (username == receivedMessage.recipient()) {
                //You..
                //You...
                //...
                //You ARE the OP
                //DUN DUN DUN
                
                // We should be doing something like
                // this here: v but it wasn't working
                usersArr = receivedMessage.path() as [String]
                println(usersArr)
            }
        }
    }
    
    func getCurrDate() -> String {
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
    }
}
