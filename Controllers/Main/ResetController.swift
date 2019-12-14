//
//  ResetController.swift
//  TheaterX
//
//  Created by Brendon Van on 8/8/19.
//  Copyright © 2019 Brendon Van. All rights reserved.
//
//MARK: - Imports
import UIKit

class ResetController: UITableViewController {

    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    //MARK: - Back Button
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "homeSegue", sender: nil)
    }
    
}
