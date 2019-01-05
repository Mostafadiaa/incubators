//
//  AddPatientVc.swift
//  incubators
//
//  Created by Mostafa Diaa on 4/23/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddPatientVc: UIViewController {
    var ref: DatabaseReference!
    var incNumArr = [String]()
    var gender = "Male"
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var babyNum: UITextField!
    
    @IBOutlet weak var weight: UITextField!
    
    @IBOutlet weak var date: UITextField!
    
    @IBOutlet weak var birthday: UITextField!
    
    
    let picker = UIDatePicker()

    var flag:Bool?
    var chosed = false
    var key:String?
    
    
    override func viewDidLoad() {
        let incsRef = Database.database().reference().child("incNum")
        incsRef.observe(.value, with: { (snapshot) in
            var inCData = [String]()
            for snap in snapshot.children
            {
                let incS = dataItems(snapshot: snap as! DataSnapshot)
                inCData.append(incS.incNum)
                
            }
            self.incNumArr = inCData
            
            
        })
        
        super.viewDidLoad()
        

        createDatePicker()
        createDatePickerHH()
    }
    
    
    
    
    @IBAction func choseInc(_ sender: Any) {
        choseInc()
        
        
        
    }
    @IBAction func AddPatientButton(_ sender: Any) {
        if chosed == true{
            if flag == true{
                AlertController.showAlert(self, title: "cano't insert ", message: "not Empty inc or \n not listed Inc")
                
            }
            else if flag == false{
                
                let babyRef = self.ref!.child("incNum").child("incNum \(key ?? "")")
                let  age = self.age.text ?? "0"
                let  babyNum = self.babyNum.text ?? "0"
                let gender = self.gender
                let weight = self.weight.text ?? "0"
                let date = self.date.text ?? "0"
                let  birthday = self.birthday.text ?? "0"
                let  parametirs =  [
                "incNum": key ?? "nil",
                "age":  age ,
                "babyNum": babyNum,
                "gender": gender,
                "weight": weight,
                "date": date,
                "birthday": birthday] as [String : Any]
                babyRef.updateChildValues(parametirs)
                AlertController.showAlert(self, title: "Done Adding", message: " The Add Completed Successfully")
            
            
        }
        

        
    
        }
        else
        {
            AlertController.showAlert(self, title: "Inc Number Warning", message: "Plz Chose Inc First")
        }
        
    }
    
    
    func choseInc(){
        
        
        let alert = UIAlertController(title: "Select your Incubator", message: "Incubators That Available Are \n \(incNumArr)", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter The incubator Number"
            textField.keyboardType = .phonePad
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields?.first
            self.key = textField!.text
            self.ref = Database.database().reference()
            if textField!.text == ""
            {
                return
            }
            else if textField!.text != ""{
                
                self.ref.child("incNum").child("incNum \(textField!.text ?? "nil")").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists(){
                        
                        self.chosed = true
                        let newIncRef = self.ref!.child("incNum").child("incNum \(textField!.text ?? "nil")")
                        newIncRef.observe(.value, with: { (snapshot) in
                            if snapshot.hasChild("babyNum"){
                                self.flag = true
                                
                            }
                            else{
                                self.flag = false
                            }
                        })
                    }
                    else{
                       AlertController.showAlert(self, title: "Warning", message: "false Inc doesn't exist")
                    }
                })
                
                
                
                
                
            }
         
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
 
        
    }
   
    func createDatePicker() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        date.inputAccessoryView = toolbar
        date.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .date
    }
    
    func createDatePickerHH() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedHH))
        toolbar.setItems([done], animated: false)
        
        birthday.inputAccessoryView = toolbar
        birthday.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .date
    }
    
    
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        date.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
    
    @objc func donePressedHH() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateStringHH = formatter.string(from: picker.date)
        
        birthday.text = "\(dateStringHH)"
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func segma(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0
        {
            gender = "Male"
        }
        else{
            gender = "Female"
        }
    }
    
    
    
    
}
