//
//  UserCell.swift
//  Edge
//
//  Created by Родион on 25.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit
import Firebase


class UserCell: UITableViewCell {
    
    
    var message: Message? {
        didSet{
            

            setNameProfile()
            detailTextLabel?.text = message?.MessageText
            
            if let sec = message?.Time?.doubleValue {
                let Date = NSDate(timeIntervalSince1970: sec)
        
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm:ss a"
                time.text = formatter.string(from: Date as Date)
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 15, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 15, y: detailTextLabel!.frame.origin.y + 3, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    private func setNameProfile() {

        if let ID = message?.InterlocutorID() {
            let ref = FIRDatabase.database().reference().child("Users").child(ID)
            ref.observe(.value, with: { (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dict["Name"] as? String
                }
            }, withCancel: nil)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(time)
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        time.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        time.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        time.widthAnchor.constraint(equalToConstant: 90).isActive = true
        time.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImage: UIImageView = {
       let pi = UIImageView()
        pi.translatesAutoresizingMaskIntoConstraints = false
        pi.layer.cornerRadius = 24
        pi.layer.masksToBounds = true
        pi.contentMode = .scaleAspectFill
        return pi
    }()
    
    let time: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    
    
    
}

