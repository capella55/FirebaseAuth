//
//  Valid-Forms.swift
//  TheaterX
//
//  Created by Brendon Van on 11/17/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import Foundation
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

//MARK: - Class Login
class Login: NSObject {
    struct Keys {
        static let defaults = UserDefaults.standard
        static let isLoggedIn = "isLoggedIn"
    }
}

//MARK: - Class Check
class Check: NSObject {
    var userEmail:String = ""
    var userPassword:String = ""
    var errorDescription:String = ""
    
    func ifAccountWasCreated() -> Bool {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: {(user , error) in
            let user = Auth.auth().currentUser
            print(error!.localizedDescription)
            if error != nil {
            // If there is something wrong give user error
                self.errorDescription = error!.localizedDescription
                

                user?.delete(completion: nil)
            
                            
            }
        
        
        })
        if (Auth.auth().currentUser != nil) {
            return true
        } else {
            return false
        }
        
    }
    
    // Checks if email is valid
    func ifEmailIsValid(emailStr:String) -> Bool {
        self.userEmail = emailStr
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
//    // Checks if name is valid
//    func isNameValid(nameStr:String) -> Bool {
//
//    }

    // Checks if password is valid
    func ifPasswordIsValid(passwordStr : String) -> Bool{
        self.userPassword = passwordStr
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: passwordStr)
    }
    
    // Checks if password is valid
    func ifPasswordVerifyIsValid(passwordStr : String,passwordVerifiedStr : String) -> Bool{
        var isValid = Bool()
        if passwordStr == passwordVerifiedStr {
            isValid = true
        } else {
            isValid = false
        }
        return isValid
    }
    
    // Checks if phone number is valid
    func ifPhoneIsValid(phoneStr: String) -> Bool {
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: phoneStr)
        return result
    }
    
}

class TheaterXDB: NSObject {
    
    // Resends email
    func resendEmail(currentUser : String) -> Bool {
        // Make sure currentUser gets the information of the actual current user
        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
        print("Email was sent")
        return true
        
    }
}


