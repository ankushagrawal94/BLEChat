//
//  FirstViewController.swift
//  BLEChat
//
//  Created by Ankush Agrawal on 10/4/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FirstViewController: JSQMessagesViewController, ConnectionsViewControllerDelegate {
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var displayName: String = "" // this is what the user thinks their name is but it really isnt
    var usersArr: [String] = [String]()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    var avatarUrlStrings = Dictionary<String, String>()
    var avatars = Dictionary<String, UIImage>()
    var senderImageUrl: String!
    var batchMessages = true
    var username = ""
    //override var sender = UIDevice.currentDevice().name as String!
    var messages = [BLEMessage]()
    
    @IBOutlet var textLabel: UILabel!
    
    @IBAction func sendText(sender: AnyObject) {
        sendMyMessage(makeMyMessage("test"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyScrollsToMostRecentMessage = true
        
        var starterMessage: BLEMessage = makeMyMessage("Hey there!")
        starterMessage.sender_ = "Someone!"
        messages.append(starterMessage)
        
        var button = UIButton(frame: CGRectMake(20, 20, 50, 30))
        button.addTarget(self, action: "sendText:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        sender = (sender != nil) ? sender : "Anonymous"
        setupAvatarImage(sender, imageUrl: avatarUrlStrings[username], incoming: false)
        senderImageUrl = avatarUrlStrings[username]

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveDataWithNotification:", name: "MSDidReceiveDataWithNotification", object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Happens when you press a received message
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        print("what");
        
        var message = makeMyMessage(text)
        
        sendMyMessage(makeMyMessage("wee"))
        
        messages.append(message)
        
        finishSendingMessage()
    }
    
    func makeMyMessage(text: String!) -> BLEMessage {
        var type: NSString = "message"
        var recipient: NSString = "Rohan’s iPhone" //Name of the target. Need to have four of these in a list somewhere
        var sender: NSString = UIDevice.currentDevice().name
        var num_bounces: Int = 0
        var path: NSArray = [UIDevice.currentDevice().name]
        
        var message = BLEMessage(type: type, sender: sender, recipient: recipient, text: text, numBounces: num_bounces, path: path)
        
        return message
    }
    
    func sendMyMessage(message: BLEMessage!) {
        var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(message)
        var allPeers = appDelegate.mcManager?.session.connectedPeers
        var error: NSError?
        appDelegate.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if((error) != nil){
            print(error?.localizedDescription)
        }
        print(allPeers)
    }
    
    func recurringMessage(receivedMessages: BLEMessage) {
        //this is the message that recurrs
        receivedMessages.numBounces_ = receivedMessages.numBounces_ + 1
        var path = NSMutableArray(array: receivedMessages.path_)
        path.addObject(UIDevice.currentDevice().name)
        var arrPath = NSArray(array: path)
        receivedMessages.path_ = arrPath
        
        var dataToSend: NSData = NSKeyedArchiver.archivedDataWithRootObject(receivedMessages)
        var allPeers = appDelegate.mcManager!.session.connectedPeers
        var error: NSError?
        appDelegate.mcManager?.session.sendData(dataToSend, toPeers: allPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        if((error) != nil){
            print(error?.localizedDescription)
        }

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
            //var temp = textLabel.text! + peerDisplayName + " wrote: " + receivedMessage.text()
            print(peerDisplayName + " wrote: " + receivedMessage.text() + "\n")
            
            //Determine if we want to trasmit this to other phones
            //Check if we are the intended target
            if( UIDevice.currentDevice().name == receivedMessage.recipient_ ) {
                //Then add this to the Textview
                messages.append(receivedMessage)
            }
            else {
                //Check if the path already contains 'us'
                /*if !contains(receivedMessage.path_, UIDevice.currentDevice().name as String)
                */
                var elapsed = self.subtractDates(NSDate(), end: receivedMessage.date()!)
                if( elapsed > 5){
                    println("discard message")
                }
                else {
                    recurringMessage(receivedMessage)
                }
                /*}*/
            }
            
        }
        /*
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
        }*/
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        println("Camera pressed!")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        
        if message.sender() == sender {
            return UIImageView(image: outgoingBubbleImageView.image, highlightedImage: outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImageView.image, highlightedImage: incomingBubbleImageView.highlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        if let avatar = avatars[message.sender()] {
            return UIImageView(image: avatar)
        } else {
            setupAvatarImage(message.sender(), imageUrl: message.imageUrl(), incoming: true)
            return UIImageView(image:avatars[message.sender()])
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.sender() == sender {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.sender() == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.sender())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.sender() == sender {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if imageUrl == nil ||  countElements(imageUrl!) == 0 {
            setupAvatarColor(name, incoming: incoming)
            return
        }
        
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let url = NSURL(string: imageUrl!)
        let image = UIImage(data: NSData(contentsOfURL: url!)!)
        let avatarImage = JSQMessagesAvatarFactory.avatarWithImage(image, diameter: diameter)
        
        avatars[name] = avatarImage
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = countElements(name)
        let initials : String? = name.substringToIndex(advance(sender.startIndex, min(3, nameLength)))
        let userImage = JSQMessagesAvatarFactory.avatarWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage
    }
    
    func getCurrDate() -> NSString {
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        var DateInFormat:NSString = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
    }
    
    func subtractDates(start: NSDate, end: NSDate) -> NSTimeInterval{
        return end.timeIntervalSinceDate(start)
    }
    
}
