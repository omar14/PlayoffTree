//
//  File.swift
//  PlayoffTree
//
//  Created by Omar AlEssa on 9/8/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import Foundation
import UIKit

func isValidPowerOfTwo(number: Int) -> Bool{
    return (number != 0) && ((number & (number - 1)) == 0)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



