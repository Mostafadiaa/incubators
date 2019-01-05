//  dataItems.swift
//  incubators
//
//  Created by Mostafa Diaa on 4/24/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//

//
//  dataItems.swift
//  incubator
//
//  Created by Mostafa Diaa on 4/15/18.
//  Copyright © 2018 Mostafa Diaa. All rights reserved.
//


import Foundation
import Firebase

struct dataItems {
    
    let incNum: String
    let age: String
    let date: String
    let babyNum: String
    let gender: String
    let weight: String
    let birthday: String
    var hum: Double
    var temp: Double
    let bodyTemp :Double
    var pulse : Double

    
//
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        incNum = snapshotValue["incNum"] as! String
        age = snapshotValue["age"] as? String ?? "0"
        date = snapshotValue["date"] as? String ?? "0"
        babyNum = snapshotValue["babyNum"] as? String ?? "0"
        gender = snapshotValue["gender"] as? String ?? "0"
        weight = snapshotValue["weight"] as? String ?? "0"
        birthday = snapshotValue["birthday"] as? String ?? "0"
        hum = snapshotValue["Humidity"] as? Double ?? 0
        temp = snapshotValue["Temperature"] as? Double ?? 0
        bodyTemp = snapshotValue["BodyTemperature"] as? Double ?? 0
        //pulse = snapshotValue["BBM"] as? Double ?? 0
        pulse = 0

//
        
        
        
        
        
        
        
    }
    
    
}
