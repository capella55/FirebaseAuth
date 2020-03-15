//
//  HomeController.swift
//  LoginTest2
//
//  Created by Brendon Van on 7/6/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import Firebase
import Lottie
import MessageUI

class HomeController: UITableViewController {
    
    //MARK: - Outlets
    
    //[Contacts]
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactView2: UIView!
    @IBOutlet weak var contactIcon: UIImageView!
    @IBOutlet weak var contactLabel: UILabel!
    
    //[Support]
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var supportView2: UIView!
    @IBOutlet weak var supportIcon: UIImageView!
    @IBOutlet weak var supportLabel: UILabel!
    
    //[System Reset]
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var resetView2: UIView!
    @IBOutlet weak var resetIcon: UIImageView!
    @IBOutlet weak var resetLabel: UILabel!
    
    //[TheaterX Care]
    @IBOutlet weak var careView: UIView!
    @IBOutlet weak var careView2: UIView!
    @IBOutlet weak var careIcon: UIImageView!
    @IBOutlet weak var careLabel: UILabel!
    
    //[Request Service]
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var serviceView2: UIView!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    
    //[Request Upgrade]
    @IBOutlet weak var upgradeView: UIView!
    @IBOutlet weak var upgradeView2: UIView!
    @IBOutlet weak var upgradeIcon: UIImageView!
    @IBOutlet weak var upgradeLabel: UILabel!
    
    //[Showroom]
    @IBOutlet weak var showroomView: UIView!
    @IBOutlet weak var showroomView2: UIView!
    @IBOutlet weak var showroomIcon: UIImageView!
    @IBOutlet weak var showroomLabel: UILabel!
    
    //[New Products]
    @IBOutlet weak var productsView: UIView!
    @IBOutlet weak var productsView2: UIView!
    @IBOutlet weak var productsIcon: UIImageView!
    @IBOutlet weak var productsLabel: UILabel!
    
    //MARK: - Variables
    //Checks if user is logged in
    let defaults = UserDefaults.standard
    struct Keys {
        static let isLoggedIn = "isLoggedIn"
    }
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - ViewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            let tvc = storyboard?.instantiateViewController(identifier: "HomeController") as! UITableViewController
            tvc.modalPresentationStyle = .fullScreen
        } else {
            print("Not available")
        }
        
        
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        contactView.layer.cornerRadius = 3
        contactView2.layer.cornerRadius = 3
        supportView.layer.cornerRadius = 3
        supportView2.layer.cornerRadius = 3
        resetView.layer.cornerRadius = 3
        resetView2.layer.cornerRadius = 3
        careView.layer.cornerRadius = 3
        careView2.layer.cornerRadius = 3
        serviceView.layer.cornerRadius = 3
        serviceView2.layer.cornerRadius = 3
        upgradeView.layer.cornerRadius = 3
        upgradeView2.layer.cornerRadius = 3
        showroomView.layer.cornerRadius = 3
        showroomView2.layer.cornerRadius = 3
        productsView.layer.cornerRadius = 3
        productsView2.layer.cornerRadius = 3
        
        //Defaulting buttons at startup
        contactView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contactIcon.image = #imageLiteral(resourceName: "Icon_contact-1")
        contactLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        supportView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        supportIcon.image = #imageLiteral(resourceName: "Icon_support-1")
        supportLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        resetView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        resetIcon.image = #imageLiteral(resourceName: "Icon_reset-1")
        resetLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        careView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        careIcon.image = #imageLiteral(resourceName: "Icon_care-1")
        careLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        serviceView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        serviceIcon.image = #imageLiteral(resourceName: "Icon_setting-1")
        serviceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        upgradeView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        upgradeIcon.image = #imageLiteral(resourceName: "Icon_upgrade-1")
        upgradeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        showroomView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        showroomIcon.image = #imageLiteral(resourceName: "Icon_showroom-1")
        showroomLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        productsView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        productsIcon.image = #imageLiteral(resourceName: "Icon_newProduct-1")
        productsLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
    
    
    //MARK: - TODO: Make a function where if a button is pressed the button that is pressed changes background color and image and text color. Make an array with names of each button.
    
    //MARK: - Contact Button
    @IBAction func contactButtonPress(_ sender: UIButton) {
        contactView2.backgroundColor = #colorLiteral(red: 0.2116515636, green: 0.5505594015, blue: 0.9998651147, alpha: 1)
        contactIcon.image = #imageLiteral(resourceName: "Icon_contact-2")
        contactLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("Contact Pressed")
    }
    
    @IBAction func contactButtonRelease(_ sender: UIButton) {
        contactView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contactIcon.image = #imageLiteral(resourceName: "Icon_contact-1")
        contactLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        performSegue(withIdentifier: "contactSegue", sender: nil)
    }
    
    //MARK: - Support Button
    @IBAction func supportButtonPress(_ sender: UIButton) {
        supportView2.backgroundColor = #colorLiteral(red: 0.2116515636, green: 0.5505594015, blue: 0.9998651147, alpha: 1)
        supportIcon.image = #imageLiteral(resourceName: "Icon_support-2")
        supportLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("Support Pressed")
        
    }
    
    @IBAction func supportButtonRelease(_ sender: UIButton) {
        supportView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        supportIcon.image = #imageLiteral(resourceName: "Icon_support-1")
        supportLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    //MARK: - Reset Button
    @IBAction func resetButtonPress(_ sender: UIButton) {
        resetView2.backgroundColor = #colorLiteral(red: 0.2116515636, green: 0.5505594015, blue: 0.9998651147, alpha: 1)
        resetIcon.image = #imageLiteral(resourceName: "Icon_reset-2")
        resetLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("Reset Pressed")
    }
    
    @IBAction func resetButtonRelease(_ sender: UIButton) {
        resetView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        resetIcon.image = #imageLiteral(resourceName: "Icon_reset-1")
        resetLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        performSegue(withIdentifier: "resetSegue", sender: nil)
    }
    
    //MARK: - TheaterX Care
    @IBAction func careButtonPress(_ sender: UIButton) {
        careView2.backgroundColor = #colorLiteral(red: 0.2116515636, green: 0.5505594015, blue: 0.9998651147, alpha: 1)
        careIcon.image = #imageLiteral(resourceName: "Icon_care-2")
        careLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("Care Pressed")
    }
    
    @IBAction func careButtonRelease(_ sender: UIButton) {
        careView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        careIcon.image = #imageLiteral(resourceName: "Icon_care-1")
        careLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        performSegue(withIdentifier: "careSegue", sender: nil)
    }
    
    //MARK: - Service Button
    @IBAction func serviceButtonPress(_ sender: UIButton) {
        serviceView2.backgroundColor = #colorLiteral(red: 0.2116515636, green: 0.5505594015, blue: 0.9998651147, alpha: 1)
        serviceIcon.image = #imageLiteral(resourceName: "Icon_setting-2")
        serviceLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("Service Pressed")
    }
    
    @IBAction func serviceButtonRelease(_ sender: UIButton) {
        serviceView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        serviceIcon.image = #imageLiteral(resourceName: "Icon_setting-1")
        serviceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        performSegue(withIdentifier: "serviceSegue", sender: nil)
    }
    
    //MARK: - Upgrade Button
    @IBAction func upgradeButtonPress(_ sender: UIButton) {
        upgradeView2.backgroundColor = #colorLiteral(red: 0.2116515636, green: 0.5505594015, blue: 0.9998651147, alpha: 1)
        upgradeIcon.image = #imageLiteral(resourceName: "Icon_upgrade-2")
        upgradeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("Upgrade Pressed")
    }
    @IBAction func upgradeButtonRelease(_ sender: UIButton) {
        upgradeView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        upgradeIcon.image = #imageLiteral(resourceName: "Icon_upgrade-1")
        upgradeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        performSegue(withIdentifier: "upgradeSegue", sender: nil)
    }
    
    //MARK: - Showroom Button
    @IBAction func showroomButtonPress(_ sender: UIButton) {
        showroomView2.backgroundColor = #colorLiteral(red: 0.2116515636, green: 0.5505594015, blue: 0.9998651147, alpha: 1)
        showroomIcon.image = #imageLiteral(resourceName: "Icon_showroom-2")
        showroomLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("Showroom Pressed")
    }
    
    @IBAction func showroomButtonRelease(_ sender: UIButton) {
        showroomView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        showroomIcon.image = #imageLiteral(resourceName: "Icon_showroom-1")
        showroomLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        performSegue(withIdentifier: "showroomSegue", sender: nil)
    }
    
    //MARK: - Products Button
    @IBAction func productsButtonPress(_ sender: UIButton) {
        productsView2.backgroundColor = #colorLiteral(red: 0.2116515636, green: 0.5505594015, blue: 0.9998651147, alpha: 1)
        productsIcon.image = #imageLiteral(resourceName: "Icon_newProduct-2")
        productsLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        print("Products Pressed")
    }
    
    @IBAction func productsButtonRelease(_ sender: UIButton) {
        productsView2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        productsIcon.image = #imageLiteral(resourceName: "Icon_newProduct-1")
        productsLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    //MARK: - Sign Out Button
    @IBAction func signOutButton(_ sender: UIButton) {
        handleSignOut()
    }

}//HomeController

//MARK: - Control Containable TableView
final class ControlContainableTableView: UITableView {
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl
            && !(view is UITextInput)
            && !(view is UISlider)
            && !(view is UISwitch) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
    
}
