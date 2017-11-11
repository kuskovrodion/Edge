//
//  NewMessage.swift
//  Edge
//
//  Created by Родион on 23.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit
import Firebase



class NewMessage: UITableViewController, UISearchResultsUpdating {
    
    let cellID = "cellID"
    
    var Users = [User]()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredUsers = [User]()
    
    var usersArray = [AnyObject]()
    var loggedUser: AnyObject?
    
    //var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        filteredUsers = Users
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.orange]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        searchController.searchBar.placeholder = "Search users by email"
        
        self.tableView.separatorStyle = .none
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1)
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        fetchUser()
        
        

        
       
    }

    
    func fetchUser() {
        FIRDatabase.database().reference().child("Users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.userID = snapshot.key
                self.Users.append(user)
                user.userName = dictionary["Name"] as? String
                user.userEmail = dictionary["Email"] as? String
                
                self.filteredUsers = self.Users
                //self.tableView.reloadData()
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
    }


    
    func Cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredUsers.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let user = filteredUsers[indexPath.row]
        
        cell.textLabel?.text = user.userName
        
        
        cell.detailTextLabel?.text = user.userEmail
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == ""{
            filteredUsers = Users
        }else {
            filteredUsers = Users.filter( { (($0.userEmail?.lowercased().contains(searchController.searchBar.text!.lowercased())))!})
        }
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 50
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.filteredUsers[indexPath.row]
            self.messagesController?.showChat(user: user)
        }
    }
    
    func Connections(userID: String) {
        let ConnectionRef = FIRDatabase.database().reference(withPath: "Users/\(userID)")
        ConnectionRef.child("Online").setValue(true)
        ConnectionRef.child("Last Online").setValue(NSDate().timeIntervalSince1970)
        ConnectionRef.observe(.value, with: { (snapshot) in
            
            guard let connect = snapshot.value as? Bool, connect
                else{
                    return
            }
            
        })
        
    }

    
    
    
    
//    func setupOnline() {
//        
//        
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textColor = .lightGray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
//        label.widthAnchor.constraint(equalToConstant: 90).isActive = true
//        label.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
//        
//    }
    
    
    
}
