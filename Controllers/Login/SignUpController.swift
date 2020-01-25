//
//  VerifyEmailController.swift
//  LoginTest2
//
//  Created by Brendon Van on 7/6/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import Firebase

class SignUpController: UITableViewController, UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerifyTextField: UITextField!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - Variables
    var uid = ""
    var email = ""
    
   
    //MARK: - Prepare Segue
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
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.phoneTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordVerifyTextField.delegate = self
        
        // TableView sets view in place
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        
        // Start listening for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: ViewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter first name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Enter phone number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])

        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordVerifyTextField.attributedPlaceholder = NSAttributedString(string: "Enter verify password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        
        transparentView.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 7
    }
    
    //MARK: - Keyboard Dismiss
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // Touching outside keyboard will close keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()

        passwordTextField.resignFirstResponder()
        passwordVerifyTextField.resignFirstResponder()
        return
    }
    
    // Pressing return on keyboard will close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return Pressed")
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()

        passwordTextField.resignFirstResponder()
        passwordVerifyTextField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardFrame.cgRectValue.height + 200
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    //MARK: - TODO MOVE TO MODEL

    
    
    
    
    
    
    
    
    //MARK: - TODO MOVE TO MODEL
    
    
    
    
    //MARK: - Handle SignUp
    func handleRegister() {
        // Checks if text field are used
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let phoneNum = phoneTextField.text, let password = passwordTextField.text, let passwordVerified = passwordVerifyTextField.text else {
            print("Form is not valid")
            return
        }
        
        // Creates User
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user , error) in
            let user = Auth.auth().currentUser
            if error != nil {
                // If there is something wrong give user error
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                user?.delete(completion: nil)
                return self.present(alert, animated: true, completion: nil)
                
                
            } else if Check().isValidEmail(emailStr: self.email) == false {
                
                //Checks if email is valid if not let user know
                let alert = UIAlertController(title: "Invalid Email", message: "Email does not exist", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                user?.delete(completion: nil)
                return self.present(alert, animated: true, completion: nil)
                
            } else if Check().isPasswordValid(password) == false{
                // Checks if password is valid if not let user know
                let alert = UIAlertController(title: "Invalid Password", message: "Password must contain 6 characters, 1 Uppercase, and 1 digit", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                user?.delete(completion: nil)
                return self.present(alert, animated: true, completion: nil)
                
            } else if Check().isPasswordVerifyValid(password, passwordVerified) {
                // Checks if phone is valid if not let user know
                let alert = UIAlertController(title: "Passwords do not match", message: "Please check your password", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                user?.delete(completion: nil)
                return self.present(alert, animated: true, completion: nil)
                
            } else if Check().isPhoneValid(phoneStr: phoneNum) == false {
                // Checks if phone is valid if not let user know
                let alert = UIAlertController(title: "Invalid Phone Number Format", message: "Format phone ###-###-####", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                user?.delete(completion: nil)
                return self.present(alert, animated: true, completion: nil)
                
            } else if user?.isEmailVerified == false {
                // Checks if email is verified if not let user know
                
                let uid = Auth.auth().currentUser!.uid
                let ref = Database.database().reference(fromURL: "https://theaterx-official.firebaseio.com/")
                let values = ["Type": "Customer", "First": firstName, "Last": lastName, "Phone": phoneNum, "Email": self.email]
                let usersReference = ref.child("users").child(uid)
                usersReference.updateChildValues(values, withCompletionBlock: {(error, ref) in
                    if error != nil {
                        print(error! )
                        return
                    }

                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    print("Saved user successfully into Firebase database")
                    
                    self.uid = uid
                    //self.email = email
                    
                    self.performSegue(withIdentifier: "verifyEmailSegue", sender: nil)
                    
                })
                
            }
            
        })
    }// HandleRegister()
    
    //MARK: - Back Button
       @IBAction func backButton(_ sender: UIButton) {
           performSegue(withIdentifier: "loginSegue", sender: nil)
       }
       
       //MARK: - SignUp Button
       @IBAction func signUpButton(_ sender: UIButton) {
           handleRegister()
       }
       
    
    

   

}
