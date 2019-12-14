//
//  Showroom.swift
//  TheaterX
//
//  Created by Brendon Van on 8/8/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit
import MapKit
import CoreLocation
import Contacts
import MessageUI

class ShowroomController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactView2: UIView!
    @IBOutlet weak var directionsButton: UIButton!
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.layer.cornerRadius = 5
        transparentView.layer.cornerRadius = 5
        contactView.layer.cornerRadius = 5
        contactView2.layer.cornerRadius = 5
        directionsButton.layer.cornerRadius = 5
        
    }
    
    //MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        checkLocationServices()
    }
    
    //MARK: - BackButton
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }
    
    //MARK: - Admin Email Button
    @IBAction func adminMail(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            //Show alert informing user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["admin@theaterx.com"])
        composer.setSubject("TheaterX Service App Contact")
        composer.setMessageBody("[INFO] \n FULL NAME: \n PHONE NUMBER: \n \n Reason for contact: ", isHTML: false)
        
        present(composer, animated: true)
    }
    
    //MARK: - Call Office Button
    @IBAction func callOffice(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "telprompt://\(4806071165)") {
            
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
    
    //MARK: - Address Button
    @IBAction func addressButton(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2DMake(33.620555,-111.903498)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "TheaterX"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    //MARK: - Directions Button
    @IBAction func directionsButton(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2DMake(33.620555,-111.903498)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "TheaterX"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    
    let alertMail = UIAlertController(title: "Device can not send Mail", message: nil, preferredStyle: .alert)
    let alertLocationServicesOff = UIAlertController(title: "Please enable Location Servies Permissions in Settings.", message: nil, preferredStyle: .alert)
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    //LOCATION
    //This set up the location manager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    //MARK: - Current Location
    //this function sets a region around location to set a distance that the map views
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //MARK: - Check for Location Services
    //This function checks if the location services are enabled
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //Show alert showing the user know they have to turn this on.
            self.present(alertLocationServicesOff, animated: true)
        }
    }
    
    //MARK: - Check Location Auth
    //This function checks location authorization on phone for app permissions.
    
    
    
    //MARK: - TODO: [MOVE TO MODEL]
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case.authorizedWhenInUse:
            let delayInSeconds = 2.0
            
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                self.locationManager.startUpdatingLocation()
            }
            
            break
        case.denied:
            //Show alert instructing them how to turn on permissions
            break
        case.notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case.restricted:
            
            break
        case.authorizedAlways:
            break
        @unknown default:
            print("Error")
        }
        //MARK: - TODO: [MOVE TO MODEL]
    }

}

//MARK: - Showroom Controller
extension ShowroomController: CLLocationManagerDelegate {
    
    
    //This function checks if location changes, latitude and logitude will update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinates = CLLocationCoordinate2D(latitude: 33.620555, longitude: -111.903498)
        let address = [CNPostalAddressStateKey: "14825 N 82nd St c", CNPostalAddressCityKey: "Scottsdale", CNPostalAddressPostalCodeKey: "85260", CNPostalAddressCountryKey: "AZ"]
        let place = MKPlacemark(coordinate: coordinates, addressDictionary: address)
        mapView.addAnnotation(place)
        let center = coordinates
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
    }
    
    //This function checks if the locationAuthorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

//MARK: - Email Controller
extension ShowroomController: MFMailComposeViewControllerDelegate {
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
