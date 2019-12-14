//
//  ContactsControllerTableViewController.swift
//  TheaterX
//
//  Created by Brendon Van on 8/8/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import MapKit
import MessageUI

class ContactController: UITableViewController {

    //MARK: - Outlets
    @IBOutlet weak var contact1View: UIView!
    @IBOutlet weak var contact1View2: UIView!

    @IBOutlet weak var contact2View2: UIView!
    @IBOutlet weak var contact2View: UIView!

    @IBOutlet weak var contact3View: UIView!
    @IBOutlet weak var contact3View2: UIView!

    @IBOutlet weak var contact4View: UIView!
    @IBOutlet weak var contact4View2: UIView!

    @IBOutlet weak var directionsButton: UIButton!
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
    }
    
    //MARK: - ViewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInsetAdjustmentBehavior = .never
        
        contact1View.layer.cornerRadius = 5
        contact1View2.layer.cornerRadius = 5
        contact2View.layer.cornerRadius = 5
        contact2View2.layer.cornerRadius = 5
        contact3View.layer.cornerRadius = 5
        contact3View2.layer.cornerRadius = 5
        contact4View.layer.cornerRadius = 5
        contact4View2.layer.cornerRadius = 5
        directionsButton.layer.cornerRadius = 5
        
    }
    
    //MARK: - TODO: CREATE ONE MAIL FUNCTION
    
    func mailJames() {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["james@theaterx.com"])
        composer.setSubject("TheaterX Service App Contact")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n \n Reason for contact: ", isHTML: false)
        
        present(composer, animated: true)
        
    }
    
    func mailJason() {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["jason@theaterx.com"])
        composer.setSubject("TheaterX Service App Contact")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n \n Reason for contact: ", isHTML: false)
        
        present(composer, animated: true)
        
    }
    
    func mailChad() {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["chad@theaterx.com"])
        composer.setSubject("TheaterX Service App Contact")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n \n Reason for contact: ", isHTML: false)
        
        present(composer, animated: true)
        
    }
    
    func mailBrent() {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["brent@theaterx.com"])
        composer.setSubject("TheaterX Service App Contact")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n \n Reason for contact: ", isHTML: false)
        
        present(composer, animated: true)
        
    }
    //MARK: - TODO: CREATE ONE MAIL FUNCTION
    
    
    
    
    //MARK: - TODO: CREATE ONE CALL FUNCTION
    func callJames() {
        if let phoneCallURL = URL(string: "telprompt://\(6026845835)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    func callJason() {
        if let phoneCallURL = URL(string: "telprompt://\(6022233642)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    func callChad() {
        if let phoneCallURL = URL(string: "telprompt://\(6027997131)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    func callBrent() {
        if let phoneCallURL = URL(string: "telprompt://\(6023008477)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    //MARK: - TODO: CREATE ONE CALL FUNCTION

    //MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }
    
    //MARK: - Contact1 Info
    @IBAction func contact1Mail(_ sender: UIButton) {
        mailJames()
    }
    @IBAction func contact1Phone(_ sender: UIButton) {
        callJames()
    }
    
    //MARK: - Contact2 Info
    @IBAction func contact2Mail(_ sender: UIButton) {
        mailJason()
    }
    @IBAction func contact2Phone(_ sender: UIButton) {
        callJason()
    }
    
    //MARK: - Contact3 Info
    @IBAction func contact3Mail(_ sender: UIButton) {
        mailChad()
    }
    @IBAction func contact3Phone(_ sender: UIButton) {
        callChad()
    }
    
    //MARK: - Contact4 Info
    @IBAction func contact4Mail(_ sender: UIButton) {
        mailBrent()
    }
    @IBAction func contact4Phone(_ sender: UIButton) {
        callBrent()
    }
    
    
    //MARK: - Directions Button
    @IBAction func directionsButton(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2DMake(33.620555,-111.903498)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "TheaterX"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
//
    }
    
}

//MARK: - Contact Controller
extension ContactController: MFMailComposeViewControllerDelegate {
    
    
    //MARK: - Mail Compose Controller
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
