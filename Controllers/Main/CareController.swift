//
//  CareController.swift
//  TheaterX
//
//  Created by Brendon Van on 8/8/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit

class CareController: UITableViewController {

    //MARK: - Outlets
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var transparentView: UIView!
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buyButton.layer.cornerRadius = 5
        transparentView.layer.cornerRadius = 5
    }
    
    //MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }
    
    //MARK: - Buy Button
    @IBAction func buyButton(_ sender: UIButton) {
    }
    
}
