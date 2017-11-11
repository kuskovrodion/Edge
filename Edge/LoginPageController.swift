//
//  LoginPageController.swift
//  Edge
//
//  Created by Родион on 22.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit
import Firebase

class LoginPageController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "mainScreenImage")!)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.addSubview(loginContainer)
        view.addSubview(LoginText)
        view.addSubview(loginTextEnter)
        view.addSubview(loginButton)
        view.addSubview(resetPassword)
        setupLoginContainer()
        setupLoginButton()
        setupResetPasswordButton()
        //   Login()
    }
    
    let  loginContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let LoginText: UILabel = {
        var text = UILabel()
        text.frame = CGRect(x: 36, y: 50, width: 300, height: 40)
        text.font = UIFont(name: "Hoefler Text", size: 40)
        text.textColor = UIColor.orange
        text.textAlignment = NSTextAlignment.center
        text.text = "Login"
        return text
    }()
    
    let loginTextEnter: UILabel = {
        var text =  UILabel()
        text.font = UIFont(name: "Hoefler Text", size: 25)
        text.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        text.textAlignment = NSTextAlignment.center
        text.text = "Enter your data"
        text.frame = CGRect(x: 33, y: 210, width: 300, height: 40)
        return text
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.titleLabel!.font = UIFont(name: "Hoefler Text", size: 20)
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
        //loginButton.frame = CGRect(x: 50, y: 270, width: 300, height: 40)
        return loginButton
    }()
    
    let resetPassword: UIButton = {
        let resetButton = UIButton()
        resetButton.titleLabel!.font = UIFont(name: "Hoefler Text", size: 20)
        resetButton.setTitle("Forgot password?", for: .normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
        //resetButton.frame = CGRect(x: 50, y: 350, width: 300, height: 40)
        
        return resetButton
    }()
    
    let userEmailTextField: UITextField = {
        let uetf = UITextField()
        uetf.placeholder = "Enter your email"
        uetf.font = UIFont(name: "Hoefler Text", size: 16)
        uetf.textColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1)
        uetf.translatesAutoresizingMaskIntoConstraints = false
        return uetf
    }()
    
    let userEmailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userPasswordTextField: UITextField = {
        let uptf = UITextField()
        uptf.placeholder = "Enter your password"
        uptf.font = UIFont(name: "Hoefler Text", size: 16)
        uptf.translatesAutoresizingMaskIntoConstraints = false
        uptf.isSecureTextEntry = true
        return uptf
    }()
    
    let userPasswordSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupLoginContainer() {
        
        loginContainer.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        loginContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15).isActive = true
        loginContainer.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        loginContainer.addSubview(userEmailTextField)
        loginContainer.addSubview(userEmailSeparator)
        loginContainer.addSubview(userPasswordTextField)
        
        userEmailTextField.leftAnchor.constraint(equalTo: loginContainer.leftAnchor, constant: 12).isActive = true
        userEmailTextField.topAnchor.constraint(equalTo: loginContainer.topAnchor).isActive = true
        userEmailTextField.widthAnchor.constraint(equalTo: loginContainer.widthAnchor).isActive = true
        userEmailTextField.heightAnchor.constraint(equalTo: loginContainer.heightAnchor, multiplier: 1/2).isActive = true
        
        userEmailSeparator.leftAnchor.constraint(equalTo: loginContainer.leftAnchor).isActive = true
        userEmailSeparator.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor).isActive = true
        userEmailSeparator.widthAnchor.constraint(equalTo: loginContainer.widthAnchor).isActive = true
        userEmailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userPasswordTextField.leftAnchor.constraint(equalTo: loginContainer.leftAnchor, constant: 12).isActive = true
        userPasswordTextField.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor).isActive = true
        userPasswordTextField.widthAnchor.constraint(equalTo: loginContainer.widthAnchor).isActive = true
        userPasswordTextField.heightAnchor.constraint(equalTo: loginContainer.heightAnchor, multiplier: 1/2).isActive = true
        
    }
    
    func setupLoginButton(){
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: loginContainer.bottomAnchor,constant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalTo: loginContainer.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loginButton.addTarget(self, action: #selector(Login), for: .touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    func setupResetPasswordButton() {
        resetPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetPassword.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 35).isActive = true
        resetPassword.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        resetPassword.heightAnchor.constraint(equalToConstant: 30).isActive = true
        resetPassword.addTarget(self, action: #selector(reset), for: .touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    func Login() {
        guard let email = userEmailTextField.text, let password = userPasswordTextField.text else {
            print ("Bad email or password")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Unable to log in.", message: "Please check that you have entered your login and password correctly.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(error ?? "")
                return
            }
            
            
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
            
            print("User seccusefuly logined")
        })
    }
    

    
    
    func reset() {

        print("Reset Button")
        let rt = ResetPasswordPage()
        present(rt, animated: true, completion: nil)
        
    }
}
