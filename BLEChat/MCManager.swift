//
//  MCManager.swift
//  BLEChat
//
//  Created by Ankush Agrawal on 10/3/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MCManager: NSObject, MCSessionDelegate {
    var peerID: MCPeerID = MCPeerID()
    var session: MCSession = MCSession()
    var browser: MCBrowserViewController = MCBrowserViewController()
    var advertiser: MCAdvertiserAssistant = MCAdvertiserAssistant()
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    //shouldn't need this one
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    //setUpPeerAndSessionWithDisplayName
    func setup(displayName: NSString){
        peerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupMCBrowser(){
        browser = MCBrowserViewController(serviceType: "chat-files", session: session)
    }
    
    func advertiseSelf(shouldAdvertise: Bool) {
        if(shouldAdvertise){
            advertiser = MCAdvertiserAssistant(serviceType: "chat-files", discoveryInfo: nil, session: session)
            advertiser.start()
        } else {
            advertiser.stop()
            //advertiser = nil //POTENTIAL SOURCE OF ERROR
        }
    }
}
