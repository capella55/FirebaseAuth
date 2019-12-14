//
//  UpgradeController.swift
//  TheaterX
//
//  Created by Brendon Van on 8/8/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import MessageUI

class UpgradeController: UITableViewController {
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }
    
    
    //MARK: TODO: Make a function that mails Upgrade Request
    
    //MARK: - TV/PROJECTOR UPGRADE
    @IBAction func tvUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[TV/Projector - UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    //MARK: - INTERNET UPGRADE
    @IBAction func internetUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[Internet/Wifi - UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    //MARK: - HVAC/CLIMATE UPGRADE
    @IBAction func hvacUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[HVAC/Climate - UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    //MARK: - SECURITY UPGRADE
    @IBAction func securityUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[Security - UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    //MARK: - CAMERA SYSTEM UPGRADE
    @IBAction func cameraUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[Camera System-UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    //MARK: - POOL/SPA UPGRADE
    @IBAction func poolUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[Pool/Spa - UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    //MARK: - LIGHTING UPGRADE
    @IBAction func lightingUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[Lighting - UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    //MARK: - COMPLETE SYSTEM UPGRADE
    @IBAction func completeUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[COMPLETE SYSTEM UPDATE - UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    
    //MARK: - OTHER UPGRADE
    @IBAction func otherUpgrade(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("[UPGRADE REQUEST] TheaterX App")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n EMAIL: \n ADDRESS: \n \n Please explain in detail what you would like to upgrade: ", isHTML: false)
        
        present(composer, animated: true)
    }
    
    
}

//MARK: - UPGRADE Controller
extension UpgradeController: MFMailComposeViewControllerDelegate {
    //MARK: - TODO: [MOVE TO MODEL]
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
    //MARK: - TODO: [MOVE TO MODEL]
}
