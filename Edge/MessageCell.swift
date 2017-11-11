//
//  MessageCell.swift
//  Edge
//
//  Created by Родион on 02.05.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    
    let text: UITextView = {
        let view = UITextView()
        view.text = "ASDASDASHASJLFHASF ASFO AHSFASF ASD"
        view.font = UIFont.systemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    
    
    var aroundWidth: NSLayoutConstraint?
    var aroundRight: NSLayoutConstraint?
    var aroundLeft: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(around)
        addSubview(text)
        
        
        aroundRight = around.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        aroundRight?.isActive = true
        
        aroundLeft = around.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        
        around.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
       
        aroundWidth = around.widthAnchor.constraint(equalToConstant: 200)
        aroundWidth?.isActive = true
        around.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

       
        text.leftAnchor.constraint(equalTo: around.leftAnchor, constant: 10).isActive = true
        text.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        text.rightAnchor.constraint(equalTo: around.rightAnchor).isActive = true
        //text.widthAnchor.constraint(equalToConstant: 200).isActive = true
        text.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    let around: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

























