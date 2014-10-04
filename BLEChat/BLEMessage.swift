//
//  BLEMessage.swift
//  BLEChat
//
//  Created by Elle Nguyen-Khoa on 10/4/14.
//  Copyright (c) 2014 AnkushAgrawal. All rights reserved.
//

import Foundation

class BLEMessage: JSQMessage {

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
    
    var recipient: NSString?
    var numBounces: Int?



}