//
//  Message.swift
//  Edge
//
//  Created by Родион on 25.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var FromID: String?
    var MessageText: String?
    var Time: NSNumber?
    var ToID: String?
    
    init(dictionary: [String: AnyObject]) {
        self.FromID = dictionary["FromID"] as? String
        self.MessageText = dictionary["Message Text"] as? String
        self.ToID = dictionary["ToID"] as? String
        self.Time = dictionary["Time"] as? NSNumber
    }
    
    func InterlocutorID() -> String? {
        if FromID == FIRAuth.auth()?.currentUser?.uid {
            return ToID
        } else {
            return FromID
        }
    }
    
    


    
}
