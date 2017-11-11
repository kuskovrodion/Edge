//
//  ViewController.swift
//  Edge
//
//  Created by Родион on 22.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit
import Firebase


class MessagesController: UITableViewController {
    
    let ID = "ID"
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(LogoutButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
        
        let image = UIImage(named: "nm")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(newMessage))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        tableView.register(UserCell.self, forCellReuseIdentifier: ID)
        
        checkIfLoggedIn()
        ShowUserMessages()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
       
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    guard let id = FIRAuth.auth()?.currentUser?.uid else {
        return
    }
    
    let mess = self.Messages[indexPath.row]
    
    if let interlocutorID = mess.InterlocutorID() {
        FIRDatabase.database().reference().child("Users Messages").child(id).child(interlocutorID).removeValue(completionBlock: { (error, ref) in
            
            if error != nil {
                print ("Failed", error ?? "")
                return
            }
            
            self.MessageRow.removeValue(forKey: interlocutorID)
            self.attmptReload()
            
        })
        
    }
    
    }
    
    
    var Messages = [Message]()
    var MessageRow = [String: Message]()
    
    
    func ShowUserMessages() {
        guard let UserID = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("Users Messages").child(UserID)
        ref.observe(.childAdded, with: { (snapshot) in
        
            let usrID = snapshot.key
            FIRDatabase.database().reference().child("Users Messages").child(UserID).child(usrID).observe(.childAdded, with: { (snapshot) in
                
                let messID = snapshot.key
                self.xd(messID: messID)
            }, withCancel: nil)
        }, withCancel: nil)
        
       ref.observe(.childRemoved, with: { (snapshot) in
        self.MessageRow.removeValue(forKey: snapshot.key)
        self.attmptReload()
       }, withCancel: nil)
    }
    
    private func xd(messID: String){
        let messREF = FIRDatabase.database().reference().child("Messages").child(messID)
        messREF.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Message(dictionary: dictionary as [String : AnyObject])
                if let interlocutorID = message.InterlocutorID() {
                    self.MessageRow[interlocutorID] = message
                }
                self.attmptReload()
            }
        }, withCancel: nil)
    }
    
    private func attmptReload() {
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.Reload), userInfo: nil, repeats: false)

    }
    
    var timer: Timer?
    
    func Reload()  {
        self.Messages = Array(self.MessageRow.values)
        self.Messages.sort(by: { (First, Second) -> Bool in
            return (First.Time?.intValue)! > (Second.Time?.intValue)!
        })

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! UserCell
        let message = Messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfLoggedIn()
    }
    
    func newMessage() {
        let nm =  NewMessage()
        nm.messagesController = self
        let nc = UINavigationController(rootViewController: nm)
        present(nc, animated: true, completion: nil)
    }
    
    func fetchAndSetupTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.navigationItem.title = dictionary["Name"] as? String
                self.Messages.removeAll()
                self.MessageRow.removeAll()
                self.tableView.reloadData()
                
                self.ShowUserMessages()
            }
   
        }, withCancel: nil)
    }
    
    func showChat(user: User) {
        let xd = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        xd.user = user
        navigationController?.pushViewController(xd, animated: true)
        navigationController?.navigationBar.tintColor = .orange
    }
    
    func LogoutButton() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let toFirstPage = FirstPage()
        toFirstPage.messagesController = self
        present(toFirstPage, animated: true, completion: nil)
        
    }
    
    func checkIfLoggedIn() {
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(LogoutButton), with: nil, afterDelay: 0)
        } else {
            
            fetchAndSetupTitle()

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mess = Messages[indexPath.row]
        
        guard let interclocutorID = mess.InterlocutorID() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("Users").child(interclocutorID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let usr = User(dictionary: dict)
            usr.userID = interclocutorID
            self.showChat(user: usr)
            
        }, withCancel: nil)
    }
    
    
    
    

}

