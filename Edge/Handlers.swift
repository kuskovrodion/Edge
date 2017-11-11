//
//  Handlers.swift
//  Edge
//
//  Created by Родион on 23.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit
import Firebase

extension RegisterPageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func selectProfileImage() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }

    
    func UserRegister() {
        guard let email = userEmailTextField.text, let password = userPasswordTextField.text, let name = userNameTextField.text else {
            print ("Bad email or password")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                let alert = UIAlertController(title: "Unable to register.", message: "Please check that you have entered  email and password correctly.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(error ?? "")
                return
            }
            guard let uid = user?.uid
                else {
                    return
            }
 
                        let UserNameImage = NSUUID().uuidString
                        let storage = FIRStorage.storage().reference().child("Profile Images").child("\(UserNameImage).png")
            
                        if let upload = UIImagePNGRepresentation(self.userProfileImage.image!) {
                            storage.put(upload, metadata: nil, completion: { (metadata, error) in
                                if error != nil {
                                    print(error ?? "")
                                    return
                                }
                                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                                    let value = ["Name": name, "Email": email, "Password": password, "KEK":profileImageURL]
                                        self.regIntoDatabaseWithUID(uid: uid, values: value as [String : AnyObject])
                    }
                })
            }
        })
    }
    

    
    private func regIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let uReference = ref.child("Users").child(uid)
        uReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err ?? "")
                return
            }
            let presentingViewController = self.presentingViewController
            self.messagesController?.navigationItem.title = values["Name"] as? String
            //self.messagesController?.fetchAndSetupTitle()
            self.dismiss(animated: false, completion: {
                presentingViewController!.dismiss(animated: false, completion: {})
            })
        })
    }
}
