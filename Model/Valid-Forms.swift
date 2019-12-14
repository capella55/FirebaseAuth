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

//MARK: - Class Login
class Login: NSObject {
    struct Keys {
        static let defaults = UserDefaults.standard
        static let isLoggedIn = "isLoggedIn"
    }
}

//MARK: - Class Check
class Check: NSObject {
    // Checks if email is valid
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    // Checks if password is valid
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    // Checks if password is valid
    func isPasswordVerifyValid(_ password : String,_ passwordVerified : String) -> Bool{
        var isValid = Bool()
        if password != passwordVerified {
            isValid = true
        } else {
            isValid = false
        }
        return isValid
    }
    
    // Checks if phone number is valid
    func isPhoneValid(phoneStr: String) -> Bool {
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: phoneStr)
        return result
    }
    
}


