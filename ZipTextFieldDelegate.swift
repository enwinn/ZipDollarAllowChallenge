//
//  ZipTextFieldDelegate.swift
//  ZipDollarAllowChallenge
//
//  Created by Eric Winn on 4/26/15.
//  Copyright (c) 2015 Eric N. Winn. All rights reserved.
//

import Foundation
import UIKit

class ZipTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // avoid undo crash bug ref: http://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield
        // confirmed it does crash as described without the check below
        if (range.length + range.location > count(textField.text)) {
            return false
        }
        
        // Only allow up to 5 decimal digits regardless of entry method: soft keyboard, external keyboard, or copy paste
        // ref: http://www.globalnerdy.com/2015/01/03/how-to-program-an-ios-text-field-that-takes-only-numeric-input-with-a-maximum-length/
        
        var result = true
        let prospectiveText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if count(string) > 0 {
            // Using predefined characterset
            let disallowedCharacterSet = NSCharacterSet.decimalDigitCharacterSet().invertedSet
            let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
            
            let resultingStringLengthIsLegal = count(prospectiveText) <= 5
            
            result = replacementStringIsLegal && resultingStringLengthIsLegal
        }
        return result
    }
}
