//
//  ViewController.swift
//  UXPhoneNumberInput
//
//  Created by Eddie Lau on 12/15/2016.
//  Copyright (c) 2016 Eddie Lau. All rights reserved.
//

import UIKit
import UXPhoneNumberInput

class ViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapButton() {
        
        let phoneInputVC = UXPhoneNumberInputViewController.instantiate()
        
        phoneInputVC.done { phoneNumber in
            
            self.phoneNumberLabel.text = phoneNumber
            self.dismiss(animated: true, completion: nil)
            
        }
        
        let navController = UINavigationController(rootViewController: phoneInputVC)
        present(navController, animated: true, completion: nil)
        
    }
}

