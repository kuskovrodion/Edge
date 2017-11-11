//
//  ChatController.swift
//  Edge
//
//  Created by Родион on 23.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.

import Foundation
import UIKit
import Firebase

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    
    let id = "ID"
    var user: User? {
        didSet{
            navigationItem.title = user?.userName
            showMessages()
        }
    }
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 6, right: 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        //setInputContainer()
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: id)
        collectionView?.keyboardDismissMode = .interactive
        //Keyboard()
    }
    
    lazy var inputCW: UIView = {
        let cw = UIView()
        cw.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        cw.backgroundColor = .white
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(Send), for: .touchUpInside)
        
        cw.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: cw.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: cw.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: cw.heightAnchor).isActive = true
        
        cw.addSubview(self.inputText)
        
        self.inputText.leftAnchor.constraint(equalTo: cw.leftAnchor, constant: 8).isActive = true
        self.inputText.centerYAnchor.constraint(equalTo: cw.centerYAnchor).isActive = true
        self.inputText.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputText.heightAnchor.constraint(equalTo: cw.heightAnchor).isActive = true
        
        let sepLine = UIView()
        sepLine.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        sepLine.translatesAutoresizingMaskIntoConstraints = false
        cw.addSubview(sepLine)
        
        sepLine.leftAnchor.constraint(equalTo: cw.leftAnchor).isActive = true
        sepLine.topAnchor.constraint(equalTo: cw.topAnchor).isActive = true
        sepLine.widthAnchor.constraint(equalTo: cw.widthAnchor).isActive = true
        sepLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

        
        return cw
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputCW
        }
        
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func Keyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShowKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func HideKeyboard(notification: NSNotification) {
        
        cwBot?.constant = 0
        
        let kbduration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: kbduration!) {
            self.view.layoutIfNeeded()
        }

    }
    
    func ShowKeyboard(notification: NSNotification) {
        let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        cwBot?.constant = -keyboard!.height
        let kbduration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: kbduration!) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func showMessages() {
        guard let id = FIRAuth.auth()?.currentUser?.uid, let ToID = user?.userID else {
            return
        }
        let userMessages = FIRDatabase.database().reference().child("Users Messages").child(id).child(ToID)
        userMessages.observe(.childAdded, with: { (snapshot) in
            
            let messID = snapshot.key
            let messRef = FIRDatabase.database().reference().child("Messages").child(messID)
            messRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }

            }, withCancel: nil)
            
            
        }, withCancel: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 70
        
        if let text = messages[indexPath.item].MessageText {
            
            height = heightForCell(text: text).height + 20
            
        }
        
        let w = UIScreen.main.bounds.width
        return CGSize(width: w, height: height)
    }
    
    private func heightForCell(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let opt = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: opt, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! MessageCell
        let message = messages[indexPath.item]
        cell.text.text = message.MessageText
        SetCell(cell: cell, message: message)
        cell.aroundWidth?.constant = heightForCell(text: message.MessageText!).width + 32
        
        return cell
    }
    
    
    private func SetCell(cell: MessageCell, message: Message) {
        
        if message.FromID == FIRAuth.auth()?.currentUser?.uid {
            
            cell.around.backgroundColor = .orange
            cell.text.textColor = .white
            cell.aroundRight?.isActive = true
            
            cell.aroundLeft?.isActive = false
            
        } else {
            
            cell.around.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
            cell.text.textColor = .white
            
            cell.aroundRight?.isActive = false
            
            cell.aroundLeft?.isActive = true
        }

        
    }
    
    var cwBot: NSLayoutConstraint?
    
    func setInputContainer() {
        let cw = UIView()
        cw.backgroundColor = .white
        cw.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cw)
        
        cw.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        cwBot = cw.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        cwBot?.isActive = true
        
        
        cw.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        cw.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(Send), for: .touchUpInside)
        
        cw.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: cw.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: cw.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: cw.heightAnchor).isActive = true
        
        cw.addSubview(inputText)
        
        inputText.leftAnchor.constraint(equalTo: cw.leftAnchor, constant: 8).isActive = true
        inputText.centerYAnchor.constraint(equalTo: cw.centerYAnchor).isActive = true
        inputText.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputText.heightAnchor.constraint(equalTo: cw.heightAnchor).isActive = true
        
        let sepLine = UIView()
        sepLine.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        sepLine.translatesAutoresizingMaskIntoConstraints = false
        cw.addSubview(sepLine)
        
        sepLine.leftAnchor.constraint(equalTo: cw.leftAnchor).isActive = true
        sepLine.topAnchor.constraint(equalTo: cw.topAnchor).isActive = true
        sepLine.widthAnchor.constraint(equalTo: cw.widthAnchor).isActive = true
        sepLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    func Send(){
        let ref  = FIRDatabase.database().reference().child("Messages")
        let child = ref.childByAutoId()
        
        let ToID = user!.userID!
        let FromID = FIRAuth.auth()!.currentUser!.uid
        let Time = Int(Date().timeIntervalSince1970)
        let dict: [String: AnyObject] = ["Message Text": inputText.text! as AnyObject, "ToID": ToID as AnyObject, "FromID": FromID as AnyObject, "Time": Time as AnyObject]
        child.updateChildValues(dict) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            self.inputText.text = nil
            
            let userMessages = FIRDatabase.database().reference(withPath: "Users Messages").child(FromID).child(ToID)
            let messID = child.key
            userMessages.updateChildValues([messID: 1])
            
            let recipRef = FIRDatabase.database().reference().child("Users Messages").child(ToID).child(FromID)
            recipRef.updateChildValues([messID: 1])
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
   
    lazy var inputText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write a message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Send()
        return true
    }
}
