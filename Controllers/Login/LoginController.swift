//
//  ViewController.swift
//  LoginTest2
//
//  Created by Brendon Van on 7/6/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginController: UITableViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var passwordToggle: UIButton!
    
    //MARK: - Variables
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var uid = ""
    var email = ""
    var iconClick = true
    var user : User?
    
    
    
    
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        

        // TableView sets view in place
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        
        
        // Start listening for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    //MARK: - ViewWillAppear()
    override func viewDidAppear(_ animated: Bool) {
        checkIfLoggedIn()
        
        transparentView.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 7
        googleButton.layer.cornerRadius = 7
        transparentView.layer.masksToBounds = true
    }
    
    //MARK: - Keyboard Dismiss
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "verifyEmailSegue":
                let vc: VerifyEmailController = segue.destination as! VerifyEmailController
                vc.uid = self.uid
                vc.email = self.email
                
            default:
                return
            }
        }
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboards()
        return
    }
    
    // Does not work with UITableView. Method in UIView for Class
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboards()
        return
    }

    
    @objc func dismissKeyboards() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return Pressed")
        dismissKeyboards()
        return true
    }
    
    // Moves keyboard to certain height
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardFrame.cgRectValue.height + 350
        } else {
            view.frame.origin.y = 0
        }
        
    }

    //MARK: - Check If Logged In
    func checkIfLoggedIn() {
        if Login.Keys.defaults.bool(forKey: Login.Keys.isLoggedIn) {
            self.performSegue(withIdentifier: "homeSegue", sender: self)
        }
    }
    
    //MARK: - Finish Logging In
    func finishLoggingIn() {
        print("Default successful set true")
        Login.Keys.defaults.set(true, forKey: Login.Keys.isLoggedIn)
    }
    
    
    //MARK: - Handle Login
    // Checks if email and password is valid
    // PerformsSegue to homePage or Gives alert of the error
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Please enter username and password")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user , error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                do {
                    try Auth.auth().signOut()
                    print("Sign out successful")
                } catch let logoutError {
                    print(logoutError)
                }
                Login.Keys.defaults.set(false, forKey: Login.Keys.isLoggedIn)
                
                return self.present(alert, animated: true, completion: nil)
                
            } else if Auth.auth().currentUser?.isEmailVerified == false {
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                let alert = UIAlertController(title: "Email has not been verified", message: "Please login to your email and verify your account.", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                Login.Keys.defaults.set(false, forKey: Login.Keys.isLoggedIn)
                
                let uid = Auth.auth().currentUser!.uid
                self.uid = uid
                self.email = email
                
                self.performSegue(withIdentifier: "verifyEmailSegue", sender: nil)
                return self.present(alert, animated: true, completion: nil)
            }
            else {
                self.finishLoggingIn()
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
                
            }
            
            
        })
    }
    
    //MARK: - Forgot PopUp
     func forgotButtonPopUp() {
         // Open popup with emailTextField.
         // Type in email then press send or cancel button
         let alert = UIAlertController(title: "Reset Password", message: "Enter your email below and press send to reset your password", preferredStyle: .alert)
         
         alert.addTextField(configurationHandler: { (_ emailTextFieldPopUp: UITextField) -> Void in
             emailTextFieldPopUp.placeholder = "Email address"
             emailTextFieldPopUp.textAlignment = .center
             
             let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: {(action) in
                 alert.dismiss(animated: true, completion: nil)
             })
             
             let sendAction = UIAlertAction(title: "Send", style: .default, handler: {(action) in
                 Auth.auth().sendPasswordReset(withEmail: emailTextFieldPopUp.text!, completion: { error in
                     if error != nil {
                         if error != nil {
                             print(error!.localizedDescription)
                             return
                             
                         } else {
                             // Email has been authenticated
                             print("Email has been authenticated")
                             return
                         }
                         
                     } else {
                         // Email has been authenticated
                         return
                     }
                 })
             })
             
         alert.addAction(closeAction)
         alert.addAction(sendAction)
             
         self.present(alert, animated: true, completion: nil)
             
         })
     }
     
    
    
     //MARK: - Login Button
     @IBAction func loginButton(_ sender: UIButton) {
         handleLogin()
         //let user = Auth.auth().currentUser
     }
     
     //MARK: - Forgot Password Button
     @IBAction func forgotPasswordButton(_ sender: UIButton) {
         forgotButtonPopUp()
     }
     
     //MARK: - SignUp Button
     @IBAction func signUpButton(_ sender: UIButton) {
         performSegue(withIdentifier: "signUpSegue", sender: nil)
     }
     
     //MARK: - PasswordView Toggle Button
     @IBAction func passwordToggle(_ sender: UIButton) {
         if(iconClick == true) {
             passwordTextField.isSecureTextEntry = false
             passwordToggle.setImage(UIImage(named: "showw") , for: .normal)
         } else {
             passwordTextField.isSecureTextEntry = true
             passwordToggle.setImage(UIImage(named: "hidew") , for: .normal)
         }

         iconClick = !iconClick
     }
     
     //MARK: - SignIn with Google Button
     @IBAction func signInWithGoogleButton(_ sender: UIButton) {

     }
     

    
}

    


