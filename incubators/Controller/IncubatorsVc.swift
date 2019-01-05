//
//  IncubatorsVc.swift
//  incubators
//
//  Created by Mostafa Diaa on 4/23/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Firebase
import Foundation
import UIKit
import UserNotifications

class IncubatorsVc: UITableViewController {
    var refFHD: DatabaseReference!
    @IBOutlet var toolsButtons: [UIButton]!
    @IBAction func handleSelection(_ sender: UIButton) {
        toolsButtons.forEach { button in
            UIView.animate(withDuration: 0.1, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }

    var ref: DatabaseReference!
    var sesg: Double?

    var items: [dataItems] = []
    var data: dataItems!
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in

            if error != nil {
                print("Authorization Unsuccessfull\(error?.localizedDescription ?? "nulllllll")")
            } else {
                print("Authorization Successfull")
            }
        }
    }

    // Notifications
    func timedNotifications(inSeconds: TimeInterval, titele: String, subtitle: String, completion: @escaping (_ Success: Bool) -> Void) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)

        let content = UNMutableNotificationContent()

        content.title = titele
        content.body = subtitle
        content.sound = UNNotificationSound.default()

        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    // end

    // get data from firebase
    func getData() {
        ref = Database.database().reference().child("incNum")
        ref?.observe(.value, with: { snapshot in
            self.items.removeAll()
            var gData: [dataItems] = []
            for snap in snapshot.children {
                let lisitem = dataItems(snapshot: snap as! DataSnapshot)
                gData.append(lisitem)
            }
            self.items = gData
            self.tableView.reloadData()

        })
    }

    // End

    // Add new incubator With IncNum Value
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Add Incubator", message: "Enter The New Inc Num", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter The New incubator Number"
            textField.keyboardType = .phonePad
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            let textField = alert?.textFields?.first
            if textField!.text == "" {
                return
            } else {
                self.ref = Database.database().reference().child("incNum")
                let newIncRef = self.ref!.child("incNum \(textField!.text ?? "nil")").child("incNum") // New inc reference
                newIncRef.setValue("\(textField!.text ?? "nil")") // New Inc IncNum Value
            }

        }))
        present(alert, animated: true, completion: nil)
    }

    // End

    // Add new incubator With IncNum Value
    @IBAction func remove(_ sender: Any) {
        var deleteref: DatabaseReference!

        let alert = UIAlertController(title: "Remove Incubator", message: "Enter The New Inc Num", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter The incubator Number"
            textField.keyboardType = .phonePad
        }
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { [weak alert] _ in
            let tex = alert?.textFields?.first
            if tex!.text == "" {
                return
            } else {
                deleteref = Database.database().reference()
                deleteref.child("incNum").child("incNum \(tex?.text ?? " ")").observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists() {
                        let deleteRef = Database.database().reference().child("incNum").child("incNum \(tex?.text ?? " ")")
                        deleteRef.removeValue()
                        AlertController.showAlert(self, title: "Deletet Successfully", message: "Incubator number \(tex?.text ?? " ") Successfully Deleted ")

                        tex?.text = nil
                    } else {
                        AlertController.showAlert(self, title: "Warning", message: "False Incubator doesn't exist")
                    }
                })
            }

        }))

        present(alert, animated: true, completion: nil)
    }

    // End

    // view data on table

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
        performSegue(withIdentifier: "showDataSegua", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? viewData {
            dist.data = items[(tableView.indexPathForSelectedRow?.row)!]
        }
    }

    // End

    // logout
    @IBAction func logout(_ sender: Any) {
        let alertLogout = UIAlertController(title: "Logout Confirmation", message: "Do you want to logout right now ?  ", preferredStyle: .alert)
        let yesSelected = UIAlertAction(title: "Yes", style: .destructive) { (_: UIAlertAction) in

            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let err {
                AlertController.showAlert(self, title: "Error", message: "\(err.localizedDescription)")
            }
        }
        let noSelected = UIAlertAction(title: "No", style: .cancel) { (_: UIAlertAction) in
            return
        }

        alertLogout.addAction(yesSelected)
        alertLogout.addAction(noSelected)
        present(alertLogout, animated: true, completion: nil)
    }

    // end
}
