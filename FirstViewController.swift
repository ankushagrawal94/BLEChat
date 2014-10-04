//
//  FirstViewController.swift
//  BLEChat
//
//  Created by Ankush Agrawal on 10/4/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FirstViewController: UIViewController {

    var appDelegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var button = UIButton(frame: CGRectMake(20, 20, 50, 30))
        button.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataWithNotification:", name: "MSDidReceiveDataWithNotification", object: nil)
        // Do any additional setup after loading the view.
    }
    
    func sendMyMessage() {
        var textMessage = "Message sent by me"
        var dataToSend = textMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var allPeers = appDelegate?.mcManager?.session.connectedPeers
        var error: NSError?
        
        appDelegate?.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if((error) != nil){
            print(error?.localizedDescription)
        }
        print("I wrote: " + textMessage)
    }
    
    func didReceiveDataWithNotification(notification: NSNotification) {
        var peerID: MCPeerID = notification.userInfo?["peerID"]! as MCPeerID
        var peerDisplayName = peerID.displayName
        
        var receivedData = notification.userInfo?["data"] as NSData
        var receivedText = NSString(data: receivedData, encoding: NSUTF8StringEncoding)
        //POTENTIAL SOURCE OF ERROR
        print(peerDisplayName + " wrote: " + receivedText!)
    }

    @IBAction func tap(sender: AnyObject) {
        sendMyMessage()
    }
}
