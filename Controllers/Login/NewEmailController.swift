//
//  NewEmailController.swift
//  TheaterX
//
//  Created by Brendon Van on 12/13/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//

import UIKit
import Firebase

class NewEmailController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.emailTextField.delegate = self
        
        // TableView sets view in place
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        
        // Start listening for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpController.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
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
        emailTextField.resignFirstResponder()
        return
    }
    
    // Pressing return on keyboard will close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
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
    
    func emailIsValid() -> Bool {
        let email = emailTextField.text!
        if Check().isValidEmail(emailStr: email) == false {
            return false
        } else {
            return true
        }
        

    }

    //MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
       
    //MARK: - Next Button
    @IBAction func nextButton(_ sender: UIButton) {
        if emailIsValid() == true {
            
            //email store to Model
            
            performSegue(withIdentifier: "newNameSegue", sender: nil)
        } else {
            let alert = UIAlertController(title: "Invalid Email", message: "Name is not valid.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
}
