//
//  logInVc.swift
//  incubator
//
//  Created by Mostafa Diaa on 4/14/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import UserNotifications
class logInVc: UIViewController {
    var data:dataItems!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
    }

    
    @IBAction func logInButton(_ sender: Any) {
        onLogin()
        
        

    }

    func onLogin(){
        if emailField.text == "" && passwordField.text == "" {
            AlertController.showAlert(self, title: "Error", message: "all Fields Required")
        }
        else{
            if emailField.text != nil && passwordField.text != nil {
                
                Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                    if  user != nil{
                        if let uid = user?.uid
                        {
                            if uid == "WfJdq91POMTlvvKkATvl5NfsGrf2"{
                                self.performSegue(withIdentifier: "adminSegue", sender: nil)
                            }
                                
                            else
                            {
                                if user!.isEmailVerified == false{
                                    AlertController.showAlert(self, title: "Verification", message: "Plz Check your  ")
                                    user!.sendEmailVerification(completion: { (_error) in
                                        if _error != nil{
                                            AlertController.showAlert(self, title: "Verification error", message: _error!.localizedDescription)
                                        }
                                        
                                    })
                                }
                                    
                                else{
                                    self.performSegue(withIdentifier: "userSegue", sender: nil)
                                }
                                
                            }
                            
                        }
                    }
                    else{
                        AlertController.showAlert(self, title: "error", message: error!.localizedDescription)
                    }
                }
            }
        }

    }
    
    
    
    
    
    
}
