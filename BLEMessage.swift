//
//  JSQMessage.swift
//  BLEChat
//
//  Created by Elle Nguyen-Khoa on 10/4/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import Foundation

class BLEMessage : NSObject, JSQMessageData, NSCoding {
    
    /**
    *  The body text of the message. This value must not be `nil`.
    *  @property (copy, nonatomic) NSString *text;
    */
    
    /**
    *  The name of user who sent the message. This value must not be `nil`.
    *  @property (copy, nonatomic) NSString *sender;
    */
    
    /**
    *  The date that the message was sent. This value must not be `nil`.
    *  @property (copy, nonatomic) NSDate *date;
    */
    var type_: String
    var text_: String
    var sender_: String
    var date_: NSDate
    var recipient_: String
    var numBounces_: Int
    var path_: NSArray

    init(type: String?, sender: String?, recipient: String?, text: String?, numBounces: Int?, path: NSArray?) {
        self.type_ = type!
        self.text_ = text!
        self.sender_ = sender!
        self.date_ = NSDate()
        self.recipient_ = recipient!
        self.numBounces_ = numBounces!
        self.path_ = path!
    }
    
    init(type: String?, sender: String?) {
        self.type_ = type!
        self.text_ = ""
        self.sender_ = sender!
        self.date_ = NSDate()
        self.recipient_ = ""
        self.numBounces_ = 0
        self.path_ = [sender!]
    }
    
    init(type: String?, sender: String?, recipient: String?) {
        self.type_ = type!
        self.text_ = ""
        self.sender_ = sender!
        self.date_ = NSDate()
        self.recipient_ = recipient!
        self.numBounces_ = 0
        self.path_ = [sender!]
    }
    
    init(type: String?, sender: String?, path: NSArray?) {
        self.type_ = type!
        self.text_ = ""
        self.sender_ = sender!
        self.date_ = NSDate()
        self.recipient_ = ""
        self.numBounces_ = 0
        self.path_ = path!
    }
    
    func type() -> String! {
        return type_;
    }
    
    func text() -> String! {
        return text_;
    }
    
    func sender() -> String! {
        return sender_;
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func recipient() -> String! {
        return recipient_;
    }
    
    func numBounces() -> Int! {
        return numBounces_;
        
    }
    
    func path() -> NSArray! {
        return path_;
    }
    
    required init(coder aDecoder: NSCoder) {
        self.type_ = aDecoder.decodeObjectForKey("type") as String
        self.text_ = aDecoder.decodeObjectForKey("text") as String
        self.sender_ = aDecoder.decodeObjectForKey("sender") as String
        self.date_ = aDecoder.decodeObjectForKey("date") as NSDate
        self.recipient_ = aDecoder.decodeObjectForKey("recipient") as String
        self.numBounces_ = aDecoder.decodeObjectForKey("numBounces") as Int
        self.path_ = aDecoder.decodeObjectForKey("path") as NSArray
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(type_ as NSString, forKey: "type")
        _aCoder.encodeObject(text_ as NSString, forKey: "text")
        _aCoder.encodeObject(sender_ as NSString, forKey: "sender")
        _aCoder.encodeObject(date_, forKey: "date")
        _aCoder.encodeObject(recipient_ as NSString, forKey: "recipient")
        _aCoder.encodeObject(numBounces_, forKey: "numBounces")
        _aCoder.encodeObject(path_ as NSArray, forKey: "path")
    }
}
