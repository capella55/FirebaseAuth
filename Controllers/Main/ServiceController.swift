//
//  serviceController.swift
//  TheaterX
//
//  Created by Brendon Van on 8/8/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import MessageUI

class ServiceController: UITableViewController {

    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    //MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }
    
    //MARK: TODO: Make a function that mails Upgrade Request
    
    
    //MARK: - No Rush Button
    @IBAction func noRushButton(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[NO RUSH - SERVICE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what the issue is: ", isHTML: false)
        
        present(composer, animated: true)
        
    }
    
    //MARK: - Week Button
    @IBAction func weekButton(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[ONE WEEK - SERVICE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what the issue is: ", isHTML: false)
        
        present(composer, animated: true)
    }
    
    //MARK: - Day Button
    @IBAction func dayButton(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[INTRADAY - SERVICE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what the issue is: ", isHTML: false)
        
        present(composer, animated: true)
    }
    
    //MARK: - ASAP Button
    @IBAction func asapButton(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[ASAP - SERVICE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what the issue is: ", isHTML: false)
        
        present(composer, animated: true)
    }
    

}

//MARK: - Service Controller
extension ServiceController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //Show error alert
            controller.dismiss(animated: true)
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed")
        case .saved:
            print("Saved")
        case .sent:
            print("Sent")
        @unknown default:
            print("Unknown Error")
        }
        
        controller.dismiss(animated: true)
    }
}
