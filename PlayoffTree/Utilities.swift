//
//  File.swift
//  PlayoffTree
//
//  Created by Omar AlEssa on 9/8/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import Foundation
import UIKit

// Check if the number entered is power of two, in order for the tree to become full
func isValidPowerOfTwo(number: Int) -> Bool{
    return (number != 0) && ((number & (number - 1)) == 0)
}

// To dismiss the UITextfield when tapping outside
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



