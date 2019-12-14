//
//  VerifyEmailController.swift
//  LoginTest2
//
//  Created by Brendon Van on 7/7/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class VerifyEmailController: UITableViewController {

    //MARK: - Outlets
    @IBOutlet weak var emailLabel: UILabel!
    
    //MARK: - Variables
    let defaults = UserDefaults.standard
    struct Keys {
        static let isLoggedIn = "isLoggedIn"
    }
    var uid = ""
    var email = ""
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView sets view in place
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        
        //MARK: TODO: MOVE TO viewWillAppear
        emailLabel.text = (Auth.auth().currentUser?.email)! + "."
        
    }
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "changeEmailSegue":
                let vc: ChangeEmailController = segue.destination as! ChangeEmailController
                vc.uid = self.uid
                vc.email = self.email
                
            default:
                return
            }
        }
    }
    
    //MARK: - Resend Email
    func resendEmail() {
        // Make sure currentUser gets the information of the actual current user
        let currentUser = Auth.auth().currentUser;
        
        if ((currentUser) != nil) {
            // User is signed in.
            Auth.auth().currentUser?.sendEmailVerification(completion: nil)
            print("Email was sent")
            
            let alert = UIAlertController(title: "Email has been sent", message: "Please login to your email and verify your account.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }));
            return self.present(alert, animated: true, completion: nil)
            
        } else {
            // No user is signed in.
            print("User is not signed in")
        }
        
    }
    
    //MARK: - Handle Sign Out
    func handleSignOut() {
        do {
            try Auth.auth().signOut()
            print("Sign out successful")
        } catch let logoutError {
            print(logoutError)
        }
        defaults.set(false, forKey: Keys.isLoggedIn)
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    
    //MARK: - Sign Out Button
    @IBAction func signOutButton(_ sender: UIButton) {
        handleSignOut()
    }
    //MARK: - Change Email Button
    @IBAction func changeEmailButton(_ sender: UIButton) {
        performSegue(withIdentifier: "changeEmailSegue", sender: nil)
    }
    
    //MARK: - Resend Email Button
    @IBAction func resendEmailButton(_ sender: UIButton) {
        resendEmail()
        
    }
    
    //MARK: - Continue Button
    @IBAction func continueButton(_ sender: UIButton) {
        Auth.auth().currentUser?.reload(completion: nil)
        if Auth.auth().currentUser?.isEmailVerified == true {
            performSegue(withIdentifier: "homeSegue", sender: nil)
        } else {
            let alert = UIAlertController(title: "Email isn't verified", message: "Please login to your email and verify your account or press this button again.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }));
            return self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
