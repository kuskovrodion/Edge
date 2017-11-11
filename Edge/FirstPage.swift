//
//  FirstPage.swift
//  Edge
//
//  Created by Родион on 22.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit

class FirstPage: UIViewController {
    
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "mainScreenImage")!)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.addSubview(mainImage)
        self.roundingUIView(self.mainImage, cornerRadiusParam: 75)
        
        view.addSubview(fpText)
        view.addSubview(fpTextContent)
        view.addSubview(startMessagingButton)
        
    }
    
    
    let mainImage: UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 110, y: 70, width: 150, height: 150))
        var image = UIImage(named: "telegram-logo")
        imageView.image = image
        return imageView
        
    }()
    
    let fpText: UILabel = {
        let text = UILabel()
        text.text = "Edge"
        text.frame = CGRect(x: 143, y: 250, width: 300, height: 40)
        text.textColor = UIColor.orange
        text.font = UIFont(name: "Hoefler Text", size: 40)
        return text
    }()
    
    let fpTextContent: UILabel = {
        let text = UILabel ()
        text.text = "The world's fastest messaging app. It's free and secure. Design by student of KNURE Kuskov Rodion"
        text.frame = CGRect(x: 33, y: 330, width: 300, height: 80)
        text.font = UIFont(name: "Hoefler Text", size: 17)
        text.lineBreakMode = .byWordWrapping
        text.textAlignment = NSTextAlignment.center;
        text.numberOfLines = 0
        text.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        return text
    }()
    
    let startMessagingButton: UIButton = {
        var MessButton = UIButton(frame: CGRect(x: 85, y: 450, width: 200, height: 50))
        MessButton.setTitleColor(.orange, for: .normal)
        MessButton.titleLabel!.font = UIFont(name: "Hoefler Text", size: 30)
        MessButton.setTitle("Start messaging", for: .normal)
        MessButton.addTarget(self, action: #selector(startMessagingAction), for: .touchUpInside)
        return MessButton
    }()
    
    
    
    func startMessagingAction() {
        let start = RegisterPageController()
        present(start, animated: true, completion: nil)
    }
    
    fileprivate func roundingUIView(_ aView: UIView!, cornerRadiusParam: CGFloat!) {
        aView.clipsToBounds = true
        aView.layer.cornerRadius = cornerRadiusParam
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
