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
    
    var nearbyServiceBrowser: MCBrowserViewController?
    var nearbyPeers: NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate?.mcManager?.setup(UIDevice.currentDevice().name)
        appDelegate?.mcManager?.advertiseSelf(true)
        browserForDevices()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peerDidChangeStateWithNotification:", name: "MSDidChangeStateNotification", object: nil)
        arrConnectedDevices = NSMutableArray()
        
        //Set up AUTOMATICALLY
        /*var peerID = MCPeerID(displayName: "advertise")
        self.nearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "ads-p2p")
        self.nearbyServiceBrowser.delegate = self
        self.nearbyServiceBrowser.startBrowsingForPeers()*/
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
    /*
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        print("Lost peer %s", peerID)
        self.nearbyPeers = [[]]
    }
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println("Error starting browsing: %s", error.localizedDescription)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        println("Accepting invite from peer: \(peerID.displayName)")
        //invitationHandler(true, session)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        
        println("didNotStartAdvertisingPeer")
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println("Session for peer: %s, changed state to: %d", peerID, state)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        println("Session received data: %s from peer: %s", data, peerID)
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        println("Session started receiving stream: %s with name: %s from peer: %s", stream, streamName, peerID)
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("Session started receiving resource: %s from peer: %s", resourceName, peerID)
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        println("didFinishReceiving")
    }

    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        
    }
    */
}
