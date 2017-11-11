import UIKit
import Firebase



class ResetPasswordPage: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "mainScreenImage")!)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
        
        //navigationItem.rightBarButtonItem = cancel
        //
        
        
        view.addSubview(blurEffectView)
        view.addSubview(ResetText)
        view.addSubview(ResetInstructionText)
        
        view.addSubview(registrationContainer)
        view.addSubview(resetButton)
        setupEmailTextField()
        setupResetButton()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.orange, for: UIControlState.normal)
        button.titleLabel!.font = UIFont(name: "Hoefler Text", size: 15)
        button.setTitle("UGHKHASFKASGFKJASHF", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancel) , for: .touchUpInside)
        button.frame.origin = CGPoint(x: 0, y: 0)
        
    }
    
    func cancel() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    let ResetText: UILabel = {
        var text = UILabel()
        text.frame = CGRect(x: 28, y: 50, width: 330, height: 40)
        text.font = UIFont(name: "Hoefler Text", size: 40)
        text.textColor = UIColor.orange
        text.textAlignment = NSTextAlignment.center
        text.text = "Password retrieval"
        return text
    }()
    
    let ResetInstructionText: UILabel = {
        let text = UILabel ()
        text.text = "Please enter email that you used to to sign in to the site."
        text.frame = CGRect(x: 33, y: 250, width: 300, height: 40)
        text.font = UIFont(name: "Hoefler Text", size: 17)
        text.lineBreakMode = .byWordWrapping
        text.textAlignment = NSTextAlignment.center;
        text.numberOfLines = 0
        text.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        return text
    }()
    
    
    
    
    let registrationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let userEmailTextField: UITextField = {
        let uetf = UITextField()
        uetf.placeholder = "Enter your email"
        uetf.font = UIFont(name: "Hoefler Text", size: 16)
        uetf.translatesAutoresizingMaskIntoConstraints = false
        return uetf
    }()
    
    lazy var resetButton: UIButton={
        
        let resetButton = UIButton(type: .system)
        resetButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
        resetButton.titleLabel!.font = UIFont(name: "Hoefler Text", size: 20)
        resetButton.setTitle("Sumbit", for: .normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        //resetButton.addTarget(self, action: #selector(UserRegister), for: .touchUpInside)
        return resetButton
        
    }()
    
    func setupResetButton() {
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetButton.topAnchor.constraint(equalTo: registrationContainer.bottomAnchor,constant: 10).isActive = true
        resetButton.widthAnchor.constraint(equalTo: registrationContainer.widthAnchor).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        resetButton.addTarget(self, action: #selector(reseting), for: .touchUpInside)
        self.view.addSubview(resetButton)
    }
    
    func setupEmailTextField() {
        
        registrationContainer.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        registrationContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registrationContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        registrationContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15).isActive = true
        registrationContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        registrationContainer.addSubview(userEmailTextField)
        
        userEmailTextField.leftAnchor.constraint(equalTo: registrationContainer.leftAnchor, constant: 12).isActive = true
        userEmailTextField.topAnchor.constraint(equalTo: registrationContainer.topAnchor).isActive = true
        userEmailTextField.widthAnchor.constraint(equalTo: registrationContainer.widthAnchor).isActive = true
        userEmailTextField.heightAnchor.constraint(equalTo: registrationContainer.heightAnchor, multiplier: 1/1).isActive = true
        
        
    }
    
    
    func reseting() {
        
        if self.userEmailTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Email field can't be empty. Enter an email.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.userEmailTextField.text!, completion: { (error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "There are no users with this email. Check email and try againg.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    self.userEmailTextField.text = ""
                    let alert = UIAlertController(title: "Success!", message: "Check your email.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
            })
            
        }
        
    }
    
    
}
