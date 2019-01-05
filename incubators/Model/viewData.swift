//
//  viewData.swift
//  incubators
//
//  Created by Mostafa Diaa on 4/24/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

import Firebase
import UIKit
class viewData: UIViewController {
    var data: dataItems?
    var Notify = IncubatorsVc()

    @IBOutlet var inCT: UILabel!
    @IBOutlet var agET: UILabel!
    @IBOutlet var babyID: UILabel!
    @IBOutlet var birthT: UILabel!
    @IBOutlet var addT: UILabel!
    @IBOutlet var genderT: UILabel!
    @IBOutlet var bodyTemp: UILabel!
    @IBOutlet var Temp: UILabel!
    @IBOutlet var bbmT: UILabel!
    @IBOutlet var HumT: UILabel!
    @IBOutlet var weightT: UILabel!

    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        ref?.observe(.value, with: { snapshot in
            let values = snapshot.value as! [String: AnyObject]
            let BBM = values["BBM"] as! Double
            let Humidity = values["Humidity"] as! Double
            let Temperature = values["Temperature"] as! Double
            let body_temp = values["BodyTemperature"] as! Double
            self.bbmT.text = "\(BBM)"
            self.HumT.text = "\(Humidity)"
            self.bodyTemp.text = "\(body_temp)"
            self.Temp.text = "\(Temperature)"

            if Temperature > 35 || Temperature < 30 {
                self.Notify.timedNotifications(inSeconds: 4, titele: "check the baby", subtitle: "someThing Wrong with Temperature \n hum : \(Humidity) \n pulse : \(BBM) \n BodyTemperature : \(body_temp) \n temp : \(Temperature)  ") { cool in
                    if cool {
                        print("done Temperature")
                    }
                }
            }

            if Humidity > 80.0 || Humidity < 40 {
                self.Notify.timedNotifications(inSeconds: 4, titele: "check the baby", subtitle: "someThing Wrong with Humidity \n hum : \(Humidity) \n pulse : \(BBM) \n BodyTemperature : \(body_temp) \n temp : \(Temperature)  ") { cool in
                    if cool {
                        print("done Humidity")
                    }
                }
            }

            if body_temp >= 30 {
                self.Notify.timedNotifications(inSeconds: 4, titele: "check the baby", subtitle: "someThing Wrong with Body Temperature \n hum : \(Humidity) \n pulse : \(BBM) \n BodyTemperature : \(body_temp) \n temp : \(Temperature)  ") { cool in
                    if cool {
                        print("done body_temp")
                    }
                }
            }

            if BBM <= 120.0 || BBM >= 180.0 {
                self.Notify.timedNotifications(inSeconds: 4, titele: "check the pulse", subtitle: "someThing Wrong with BBM \n hum : \(Humidity) \n pulse : \(BBM) \n bodyTemp : \(body_temp) \n temp : \(Temperature)  ") { cool in
                    if cool {
                        print("done BBM")
                    }
                }
            }

        })
        inCT.text = data?.incNum ?? "0"
        agET.text = data?.age ?? "nil"
        babyID.text = data?.babyNum ?? "0"
        birthT.text = data?.birthday ?? "nil"
        addT.text = data?.date ?? "nil"
        genderT.text = data?.gender ?? "nil"
        weightT.text = data?.weight ?? "nil"

        // Do any additional setup after loading the view.
    }

    @IBAction func dis(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
