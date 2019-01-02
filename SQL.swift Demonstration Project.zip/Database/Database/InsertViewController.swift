//
//  InsertViewController.swift
//  Database
//
//  Created by Sarwaan Ansari on 12/12/18.
//  Copyright © 2018 Sarwaan Ansari. All rights reserved.
//

import UIKit
import SQLite

class InsertViewController: UIViewController {

    
    @IBOutlet weak var SelectFlowers: UITextField!
    @IBOutlet weak var SightedLocation: UITextField!
    @IBOutlet weak var PersonsName: UITextField!
    @IBOutlet weak var Date: UITextField!
    @IBOutlet weak var DelName: UITextField!
    @IBOutlet weak var SelAttr: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for row in Comname {
            for (index, comname) in Comname.columnNames.enumerated() {
                FlowerArr.append(row[index] as! String)
            }
        }
        var thePicker = UIPickerView()
        SelectFlowers.inputView = thePicker
        DelName.inputView = thePicker
        SelAttr.inputView = thePicker
        thePicker.delegate = self
        thePicker.dataSource = self
        
    }
    
    func refreshonClick() {
        Comname = try! db.prepare("SELECT COMNAME FROM FLOWERS;")
        FlowerArr = []
        for row in Comname {
            for (index, comname) in Comname.columnNames.enumerated() {
                FlowerArr.append(row[index] as! String)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnInsertClick(_ sender: Any) {
        let insert = try! db.run("INSERT INTO SIGHTINGS(NAME, PERSON, LOCATION, SIGHTED) VALUES ('" + SelectFlowers.text! + "','" + PersonsName.text! + "','" + SightedLocation.text! + "','" + Date.text! + "');")
    }
    var s = 0
    @IBAction func SelectOnClick(_ sender: UIButton) {
        refreshonClick()
        let sighted = try! db.prepare("SELECT COMNAME AS NAME, LOCATION, PERSON, SIGHTED FROM FLOWERS JOIN SIGHTINGS ON NAME = COMNAME WHERE NAME = '" + SelectFlowers.text! + "' ORDER BY SIGHTED DESC;");
        for row in sighted {
            for (index, sighted) in sighted.columnNames.enumerated() {
                FlowerSighted.append(row[index] as! String)
            }
        }
        for i in stride(from: 1, to:FlowerSighted.count, by:4) {
            Location.append(FlowerSighted[i])
        }
        for i in stride(from: 2, to:FlowerSighted.count, by:4) {
            Person.append(FlowerSighted[i])
        }
        for i in stride(from: 3, to:FlowerSighted.count, by:4) {
            Sightedon.append(FlowerSighted[i])
        }
        
        FlowerSighted = []
        for i in stride(from: 0, to: Location.count, by: 1) {
            FlowerSighted.append(Location[i] + "-" + Person[i] + "-" + Sightedon[i])
        }
        s = 1
        reloadInputViews()
        
    }
    var N = ""
    var L = ""
    var P = ""
    var Sight = ""
    
    @IBAction func DeleteFlower(_ sender: Any) {
        var value = 0
        for i in 0...FlowerSighted.count {
            if (SelAttr.text == FlowerSighted[i]) {
                value = i
                break
            }
        }
        N = SelectFlowers.text!
        L = Location[value]
        P = Person[value]
        Sight = Sightedon[value]
        let delete = try! db.run("BEGIN; DELETE FROM SIGHTINGS WHERE NAME = '" + SelectFlowers.text! + "' AND PERSON = '" + P + "' AND LOCATION = '" + L + "' AND SIGHTED = '" + Sight + "'; COMMIT;")
    }
}

extension InsertViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if (FlowerSighted.isEmpty) {
            return 1
        }
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch s {
        case 0:
            return FlowerArr.count
        case 1:
            return FlowerSighted.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch s {
        case 0:
            return FlowerArr[row]
        case 1:
            if (row > FlowerSighted.count) {
                return "Buffering"
            }
            return FlowerSighted[row]
        default:
            return "Select Flower"
        }
    }
    func pickerView(  _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch s{
        case 0:
            if (component > 1) {
                
            }
            SelectFlowers.text = FlowerArr[row]
            DelName.text = FlowerArr[row]
            self.SelectFlowers.reloadInputViews()
        case 1:
            if (FlowerSighted.isEmpty) {
                break
            }
            SelAttr.text = FlowerSighted[row]
            self.SelAttr.reloadInputViews()
        default:
            break
        }
    }
}
