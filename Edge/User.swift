//
//  User.swift
//  Edge
//
//  Created by Родион on 23.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import Foundation
class User: NSObject {
    var userID: String?
    var userName: String?
    var userEmail: String?
    var imageUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        
        self.userID = dictionary["ID"] as? String
        self.userName = dictionary["UserName"] as? String
        self.userEmail = dictionary["UserEmail"] as? String
        
    }
}
