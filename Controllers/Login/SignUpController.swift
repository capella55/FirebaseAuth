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
    
    //MARK: - Handle SignUp
//    func handleRegister() {
        //Checks if text field are used
//        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let phoneNum = phoneTextField.text, let password = passwordTextField.text, let passwordVerified = passwordVerifyTextField.text else {
//            print("Form is not valid")
//            return
//        }
//
//        //Creates User
//        Auth.auth().createUser(withEmail: email, password: password, completion: {(user , error) in
//            let user = Auth.auth().currentUser
//            if error != nil {
//                // If there is something wrong give user error
//                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
//                    alert.dismiss(animated: true, completion: nil)
//                }))
//
//                user?.delete(completion: nil)
//                return self.present(alert, animated: true, completion: nil)
//
//
//            } else if Check().ifPasswordIsValid(passwordStr: password) == false{
//                // Checks if password is valid if not let user know
//                let alert = UIAlertController(title: "Invalid Password", message: "Password must contain 6 characters, 1 Uppercase, and 1 digit", preferredStyle: UIAlertController.Style.alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
//                    alert.dismiss(animated: true, completion: nil)
//                }))
//
//                user?.delete(completion: nil)
//                return self.present(alert, animated: true, completion: nil)
//
//            } else if Check().ifPasswordVerifyIsValid(passwordStr: password, passwordVerifiedStr: passwordVerified) {
//                // Checks if phone is valid if not let user know
//                let alert = UIAlertController(title: "Passwords do not match", message: "Please check your password", preferredStyle: UIAlertController.Style.alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
//                    alert.dismiss(animated: true, completion: nil)
//                }))
//
//                user?.delete(completion: nil)
//                return self.present(alert, animated: true, completion: nil)
//
//            } else if Check().ifPhoneIsValid(phoneStr: phoneNum) == false {
//                // Checks if phone is valid if not let user know
//                let alert = UIAlertController(title: "Invalid Phone Number Format", message: "Format phone ###-###-####", preferredStyle: UIAlertController.Style.alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
//                    alert.dismiss(animated: true, completion: nil)
//                }))
//
//                user?.delete(completion: nil)
//                return self.present(alert, animated: true, completion: nil)
//
//            } else if user?.isEmailVerified == false {
//                // Checks if email is verified if not let user know
//
//                let uid = Auth.auth().currentUser!.uid
//                let ref = Database.database().reference(fromURL: "https://theaterx-official.firebaseio.com/")
//                let values = ["Type": "Customer", "First": firstName, "Last": lastName, "Phone": phoneNum, "Email": self.email]
//                let usersReference = ref.child("users").child(uid)
//                usersReference.updateChildValues(values, withCompletionBlock: {(error, ref) in
//                    if error != nil {
//                        print(error! )
//                        return
//                    }
//
//                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
//                    print("Saved user successfully into Firebase database")
//
//                    self.uid = uid
//                    //self.email = email
//
//                    self.performSegue(withIdentifier: "verifyEmailSegue", sender: nil)
//
//                })
//
//            }
//
//        })
//    }// HandleRegister()
//
//

    }

