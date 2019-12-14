//
//  ChangeEmailController.swift
//  LoginTest2
//
//  Created by Brendon Van on 7/6/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import Firebase

class ChangeEmailController: UITableViewController, UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Variables
    var uid = ""
    var email = ""
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView sets view in place
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag

        self.newEmailTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(ChangeEmailController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeEmailController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeEmailController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: - Keyboard Dismiss
    deinit {
        // Stop listening to keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newEmailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardFrame.cgRectValue.height + 275
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    // Pressing Return on keyboard will close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return Pressed")
        newEmailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "verifyEmailSegue", sender: nil)
    }
    
    //MARK: - Change Email Button
    @IBAction func changeEmailButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email, password: self.passwordTextField.text!, completion: {(user , error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
            } else {
                Auth.auth().currentUser?.updateEmail(to: self.newEmailTextField.text!, completion: {(error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        
                        return self.present(alert, animated: true, completion: nil)
                        
                        
                        
                    } else {
                        let alert = UIAlertController(title: "Email has been updated", message: "You will be sent back to verify your email", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                            alert.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: "verifyEmailSegue", sender: nil)
                        }))
                        
                        return self.present(alert, animated: true, completion: nil)
                    }
                }) //Update email
            } //else
        }) //Auth Sign In

    } //change Email Button
}// class
