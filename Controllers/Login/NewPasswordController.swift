//
//  NewPasswordController.swift
//  TheaterX
//
//  Created by Brendon Van on 12/13/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//

import UIKit

class NewPasswordController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerifyTextField: UITextField!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.passwordTextField.delegate = self
        self.passwordVerifyTextField.delegate = self
        
        // Text field hint
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        // TableView sets view in place
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        
        // Start listening for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(NewPasswordController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewPasswordController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewPasswordController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        transparentView.layer.cornerRadius = 10
        nextButton.layer.cornerRadius = 7
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
        passwordTextField.resignFirstResponder()
        passwordVerifyTextField.resignFirstResponder()
        return
    }
    
    // Pressing return on keyboard will close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    func isPasswordValid() -> Bool {
        let password = passwordTextField.text!
        let passwordVerify = passwordVerifyTextField.text!
        
        if Check().ifPasswordVerifyIsValid(passwordStr: password, passwordVerifiedStr: passwordVerify) == true {
            print("Password's match")
            if Check().ifPasswordIsValid(passwordStr: password) == true {
                print("Password is Valid")
                return true
            } else {
                //Popup with why
                return false
            }
        } else {
            return false
        }
        

    }

    //MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "newUserSegue", sender: nil)
    }
       
    //MARK: - Next Button
    @IBAction func nextButton(_ sender: UIButton) {
        if isPasswordValid() == true {
            print("Password is valid 2 nextbutton")
            if Check().ifAccountWasCreated() == true {
                print("Password is valid 2 nextbutton")
                performSegue(withIdentifier: "verifyEmailSegue", sender: nil)
            } else {
                //error with account creation
                print("Error")
                let alert = UIAlertController(title: "Error", message: Check().errorDescription, preferredStyle: UIAlertController.Style.alert)
                
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                                alert.dismiss(animated: true, completion: nil)
                            }))
                return self.present(alert, animated: true, completion: nil)
            }
            
            
        } else {
            let alert = UIAlertController(title: "Invalid Password", message: "Password is not valid.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    }

}
