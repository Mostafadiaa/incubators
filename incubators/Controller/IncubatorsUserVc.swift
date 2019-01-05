//
//  IncubatorsUserVc.swift
//  incubators
//
//  Created by Mostafa Diaa on 5/25/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import UserNotifications
class IncubatorsUserVc: UITableViewController {
    var ref: DatabaseReference!
    var items :[dataItems] = []
    var data:dataItems!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                
                print("Authorization Unsuccessfull\(error?.localizedDescription ?? "nulllllll")")
            }else {
                print("Authorization Successfull")
                
            }
        }
        
    }
    //Notifications
    func timedNotifications(inSeconds: TimeInterval,titele:String,subtitle:String, completion: @escaping (_ Success: Bool) -> ()) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let content = UNMutableNotificationContent()
        
        content.title = titele
        content.body = subtitle
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            }else {
                completion(true)
            }
        }
        
    }
    //end
    
    
    //get data from firebase
    func getData() {
        
        ref = Database.database().reference().child("incNum")
        ref?.observe(.value, with: { (snapshot) in
            self.items.removeAll()
            var gData :[dataItems] = []
            for snap in snapshot.children
            {
                let lisitem = dataItems(snapshot: snap as! DataSnapshot)
                gData.append(lisitem)
                
            }
            self.items = gData
            self.tableView.reloadData()
            
            
        })
        
        
        
    }
    //End
    //view data on table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let dataTableItems = items[indexPath.row]
        cell.textLabel?.text = "incNum \(dataTableItems.incNum)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDataSeguaU", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? viewData{
            dist.data = items[(tableView.indexPathForSelectedRow?.row)!]
            
            
        }
        
        
    }
    
    
    
    //End
    
    
    @IBOutlet var toolsButtons: [UIButton]!
    
    @IBAction func handleSelection(_ sender: UIButton) {
        toolsButtons.forEach { (button) in
            UIView.animate(withDuration: 0.1, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    
    
    
    
    
    
    
    //logout
    @IBAction func logoutButt(_ sender: Any) {
        
        
        let alertLogout = UIAlertController(title: "Logout Confirmation", message: "Do you want to logout right now ?  ", preferredStyle: .alert)
        let yesSelected = UIAlertAction(title: "Yes", style: .destructive) { (action:UIAlertAction) in
            
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let err {
                AlertController.showAlert(self, title: "Error", message: "\(err.localizedDescription)")

                
                
                
            }
            
            
        }
        let noSelected = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
            return
        }
        
        alertLogout.addAction(yesSelected)
        alertLogout.addAction(noSelected)
        self.present(alertLogout,animated: true,completion: nil)
        
        
        
        
       
    }
    //end
    
    //delete currentUser
    
    @IBAction func deleteAccount(_ sender: Any) {
        let alertDelete = UIAlertController(title: "Delete Account Confirmation", message: "This account will be deleted .\n This Acction cannot be undone ", preferredStyle: .alert)
        let YesSelected = UIAlertAction(title: "Yes", style: .destructive) { (action:UIAlertAction) in
            let user =  Auth.auth().currentUser
            user?.delete(completion: { (err) in
                if let error = err{
                    print(error.localizedDescription)
                }
                else{
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }
        let NoSelected = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
            return
        }
        
        alertDelete.addAction(YesSelected)
        alertDelete.addAction(NoSelected)
        self.present(alertDelete,animated: true,completion: nil)
        
    
        
    }
    
    
    
    
}
