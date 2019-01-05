//
//  AlertController.swift
//  incubators
//
//  Created by Mostafa Diaa on 4/23/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Foundation
import UIKit
class AlertController {
    static func showAlert(_ inViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inViewController.present(alert, animated: true, completion: nil)
    }
    
    
}
