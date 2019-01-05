//
//  signUp.swift
//  incubators
//
//  Created by Mostafa Diaa on 4/24/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class signUp: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!

    func onSignUp(){
        if  emailField.text == "" && passwordField.text == ""{
            AlertController.showAlert(self, title: "error", message: "all Fields Required ")
        }
        else{
            if emailField.text != nil && passwordField.text != nil {
                Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user,
                    error) in
                    if user != nil {
                        AlertController.showAlert(self, title: "welcome", message: "You Have Successfull signed up ")
                        user!.sendEmailVerification(completion: { (_error) in
                            if _error != nil{
                                AlertController.showAlert(self, title: "Verification error", message: _error!.localizedDescription)
                            }
                            
                        })                    }
                    else{
                        AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    }
                }

            }
        }

    }
                @IBAction func signUpButton(_ sender: Any) {
            //sign up a new user only shows for the admin
                    onSignUp()

             }
            }
