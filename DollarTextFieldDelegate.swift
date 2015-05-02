//
//  DollarTextFieldDelegate.swift
//  ZipDollarAllowChallenge
//
//  Created by Eric Winn on 4/26/15.
//  Copyright (c) 2015 Eric N. Winn. All rights reserved.
//

import Foundation
import UIKit

class DollarTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // avoid undo crash bug ref: http://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield
        // confirmed it does crash as described without the check below
        if (range.length + range.location > count(textField.text)) {
            return false
        }
        println("\n----\n  range: \(range)\n  range.length: \(range.length)\n  range.location: \(range.location)\n  textCount: \(count(textField.text))\n  textTield.text: \(textField.text)\n  string: \(string)")
        
        let newText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        println("\n  newText: \(newText)")
        
        // Used Chrisna's solution
        // Only allow decimal digits regardless of entry method: soft keyboard, external keyboard, or copy paste
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        
        for character in string.unicodeScalars{
            if !digits.longCharacterIsMember(character.value) {
                return false
            }
        }
        
        // Construct the new content
        var newDigitString = ""
        for character in newText.unicodeScalars {
            if digits.longCharacterIsMember(character.value) {
                newDigitString.append(character)
                println("\n    c: ||\(character)|, newDigitString: \(newDigitString)")
            }
        }
        
        // Format into a currency string
        let pennies = NSDecimalNumber(string: newDigitString)
        println("\n  pennies: \(pennies)")
        if pennies == NSDecimalNumber.notANumber() {
            textField.text = "$0.00"
        } else {
            let dollars = pennies.decimalNumberByDividingBy(100)
            println("\n  dollars: \(dollars)")
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            let proposedText = formatter.stringFromNumber(dollars)
            // Max allowed: $999,999,999.99 (length is 15)
            println("\n  proposedText: \(proposedText)")
            println("\n  proposedText Type: \(_stdlib_getDemangledTypeName(proposedText))")
            // force a cast from String? to String
            if let proposedText = proposedText {
                println("\n  proposedText(wrapped): \(proposedText)")
                println("\n  proposedText(wrapped) Type: \(_stdlib_getDemangledTypeName(proposedText))")
                if (proposedText as NSString).length > 15 {
                    return false
                }
            }
            textField.text = proposedText
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text.isEmpty {
            textField.text = "$0.00"
        }
    }
    
}
