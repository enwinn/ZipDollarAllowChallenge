//
//  ViewController.swift
//  ZipDollarAllowChallenge
//
//  Created by Eric Winn on 4/26/15.
//  Copyright (c) 2015 Eric N. Winn. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var dollarTextField: UITextField!
    @IBOutlet weak var allowEditTextField: UITextField!
    @IBOutlet weak var allowEditSwitch: UISwitch!
    
    let zipcodeDelegate = ZipTextFieldDelegate()
    let dollarDelegate = DollarTextFieldDelegate()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.zipTextField.delegate = zipcodeDelegate
        self.dollarTextField.delegate = dollarDelegate
        self.allowEditTextField.delegate = self
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return allowEditSwitch.on ? true : false
    }
    

}

