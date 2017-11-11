//
//  RegisterPageController.swift
//  Edge
//
//  Created by Родион on 22.04.17.
//  Copyright © 2017 Rodion Kuskov. All rights reserved.
//

import UIKit
import Firebase

class RegisterPageController: UIViewController {
    
    var messagesController: MessagesController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "mainScreenImage")!)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        view.addSubview(registrationContainer)
        view.addSubview(registerButton)
        view.addSubview(userProfileImage)
        view.addSubview(WelcomeText)
        view.addSubview(loginButton)
        
        setupRegistrationContainer()
        setupRegisterButton()
        setupLoginButton()
        setupProfileImage()
        
         self.roundingUIView(self.userProfileImage, cornerRadiusParam:80)
    }
     func roundingUIView(_ aView: UIView!, cornerRadiusParam: CGFloat!) {
        aView.clipsToBounds = true
        aView.layer.cornerRadius = cornerRadiusParam
    }
    
    let WelcomeText: UILabel = {
        var yourLabel: UILabel = UILabel()
        yourLabel.frame = CGRect(x: 36, y: 40, width: 300, height: 40)
        yourLabel.font = UIFont(name: "Hoefler Text", size: 40)
        yourLabel.textColor = UIColor.orange
        yourLabel.textAlignment = NSTextAlignment.center
        yourLabel.text = "Welcome to Edge"
        return yourLabel
    }()
    
    let registrationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var registerButton: UIButton={
        let registerButton = UIButton(type: .system)
        registerButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
        registerButton.titleLabel!.font = UIFont(name: "Hoefler Text", size: 20)
        registerButton.setTitle("Register", for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(UserRegister), for: .touchUpInside)
        return registerButton
    }()
    
    lazy var loginButton: UIButton={
        let login = UIButton(type: .system)
        login.setTitleColor(UIColor.orange, for: UIControlState.normal)
        login.titleLabel!.font = UIFont(name: "Hoefler Text", size: 20)
        login.setTitle("Already registered?", for: .normal)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.addTarget(self, action: #selector(LB), for: .touchUpInside)
        return login
    }()

    
    lazy var userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user-image-with-black-background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    let userNameTextField: UITextField = {
        let untf = UITextField()
        untf.placeholder = "Enter your name and second name"
        untf.font = UIFont(name: "Hoefler Text", size: 16)
        untf.translatesAutoresizingMaskIntoConstraints = false
        return untf
    }()
    
    let userNameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let userEmailTextField: UITextField = {
        let uetf = UITextField()
        uetf.placeholder = "Enter your email"
        uetf.font = UIFont(name: "Hoefler Text", size: 16)
        uetf.translatesAutoresizingMaskIntoConstraints = false
        return uetf
    }()
    
    let userEmailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
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
    
    func setupRegistrationContainer() {
        registrationContainer.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        registrationContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registrationContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        registrationContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15).isActive = true
        registrationContainer.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        registrationContainer.addSubview(userNameTextField)
        registrationContainer.addSubview(userEmailTextField)
        registrationContainer.addSubview(userPasswordTextField)
        registrationContainer.addSubview(userNameSeparator)
        registrationContainer.addSubview(userEmailSeparator)
        registrationContainer.addSubview(userPasswordSeparator)
        
        userNameTextField.leftAnchor.constraint(equalTo: registrationContainer.leftAnchor, constant: 12).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: registrationContainer.topAnchor).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: registrationContainer.widthAnchor).isActive = true
        userNameTextField.heightAnchor.constraint(equalTo: registrationContainer.heightAnchor, multiplier: 1/3).isActive = true
        
        userNameSeparator.leftAnchor.constraint(equalTo: registrationContainer.leftAnchor).isActive = true
        userNameSeparator.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        userNameSeparator.widthAnchor.constraint(equalTo: registrationContainer.widthAnchor).isActive = true
        userNameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        userEmailTextField.leftAnchor.constraint(equalTo: registrationContainer.leftAnchor, constant: 12).isActive = true
        userEmailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        userEmailTextField.widthAnchor.constraint(equalTo: registrationContainer.widthAnchor).isActive = true
        userEmailTextField.heightAnchor.constraint(equalTo: registrationContainer.heightAnchor, multiplier: 1/3).isActive = true
        
        userEmailSeparator.leftAnchor.constraint(equalTo: registrationContainer.leftAnchor).isActive = true
        userEmailSeparator.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor).isActive = true
        userEmailSeparator.widthAnchor.constraint(equalTo: registrationContainer.widthAnchor).isActive = true
        userEmailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        userPasswordTextField.leftAnchor.constraint(equalTo: registrationContainer.leftAnchor, constant: 12).isActive = true
        userPasswordTextField.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor).isActive = true
        userPasswordTextField.widthAnchor.constraint(equalTo: registrationContainer.widthAnchor).isActive = true
        userPasswordTextField.heightAnchor.constraint(equalTo: registrationContainer.heightAnchor, multiplier: 1/3).isActive = true
        
    }
    //=================================

    
    
    
    func setupProfileImage() {
        userProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userProfileImage.bottomAnchor.constraint(equalTo: registrationContainer.topAnchor, constant: -10).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 170).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    
    func setupRegisterButton() {
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: registrationContainer.bottomAnchor,constant: 10).isActive = true
        registerButton.widthAnchor.constraint(equalTo: registrationContainer.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //registerButton.addTarget(self, action: #selector(AfterRegistration), for: .touchUpInside)
        self.view.addSubview(registerButton)
    }
    
    func setupLoginButton() {
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor,constant: 10).isActive = true
        loginButton.widthAnchor.constraint(equalTo: registerButton.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //registerButton.addTarget(self, action: #selector(AfterRegistration), for: .touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    func LB() {
        let login = LoginPageController()
        present(login, animated: true, completion: nil)
    }
    
    
    
        
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
