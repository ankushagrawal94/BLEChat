//
//  ConnectionsViewController.swift
//  BLEChat
//
//  Created by Ankush Agrawal on 10/3/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ConnectionsViewControllerDelegate {
    func callSendEnter()
}

class ConnectionsViewController: UIViewController, MCBrowserViewControllerDelegate, UITextFieldDelegate {
    
    var appDelegate: AppDelegate?
    var arrConnectedDevices: NSMutableArray = NSMutableArray(object: UIDevice.currentDevice().name)
    var delegate: ConnectionsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate?.mcManager?.setup(UIDevice.currentDevice().name)
        appDelegate?.mcManager?.advertiseSelf(true)
        browserForDevices()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peerDidChangeStateWithNotification:", name: "MSDidChangeStateNotification", object: nil)
        arrConnectedDevices = NSMutableArray()
        // Do any additional setup after loading the view.
    }
    
    func browserForDevices() {
        appDelegate?.mcManager?.setupMCBrowser()
        appDelegate?.mcManager?.browser?.delegate = self
        var tempBrowser = appDelegate?.mcManager?.browser
        //self.navigationController?.pushViewController(appDelegate?.mcManager?.browser?, animated: true)
        println("before presenting")
        self.presentViewController(tempBrowser!, animated: true, completion: nil)
        println("after presenting")
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        appDelegate?.mcManager?.browser?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        appDelegate?.mcManager?.browser?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func peerDidChangeStateWithNotification (notification: NSNotification) {
        var peerID = notification.userInfo?["peerID"] as MCPeerID
        var displayName = peerID.displayName
        var state = notification.userInfo?["state"] as Int
        
        if state != MCSessionState.Connecting.rawValue {
            if state == MCSessionState.Connected.rawValue {
                println("connected")
                arrConnectedDevices.addObject(displayName)
                //Call delegate method
                var firstVC = FirstViewController()
                firstVC.callSendEnter()
                //self.delegate?.callSendEnter()
            }
            else if state == MCSessionState.NotConnected.rawValue && arrConnectedDevices.count > 0{
                println("not connected")
                var indexOfPeer = arrConnectedDevices.indexOfObject(displayName)
                arrConnectedDevices.removeObjectAtIndex(indexOfPeer)
            }
            
            print(arrConnectedDevices)
            var peersExist = appDelegate?.mcManager?.session.connectedPeers.count == 0
            self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func disconnect() {
        appDelegate?.mcManager?.session.disconnect()
        arrConnectedDevices.removeAllObjects()
    }
}
