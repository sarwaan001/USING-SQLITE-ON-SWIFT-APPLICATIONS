//
//  UpdateViewControl.swift
//  Database
//
//  Created by Sarwaan Ansari on 12/12/18.
//  Copyright © 2018 Sarwaan Ansari. All rights reserved.
//

import UIKit
import SQLite

class UpdateViewControl: UIViewController {
    @IBOutlet weak var SelectFlowers: UITextField!
    @IBOutlet weak var LocUpdate: UITextField!
    @IBOutlet weak var NewLoc: UITextField!
    @IBOutlet weak var NewPerson: UITextField!
    @IBOutlet weak var NewDate: UITextField!
    @IBOutlet weak var NewGenus: UITextField!
    @IBOutlet weak var NewSpecies: UITextField!
    
    
    var s = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        for row in Comname {
            for (index, comname) in Comname.columnNames.enumerated() {
                FlowerArr.append(row[index] as! String)
            }
        }
        var thePicker = UIPickerView()
        var theLocPicker = UIPickerView()
        
        SelectFlowers.inputView = thePicker
        LocUpdate.inputView = theLocPicker
        thePicker.delegate = self
        thePicker.dataSource = self
        
        theLocPicker.delegate = self
        theLocPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshonClick() {
        FlowerArr = []
        for row in Comname {
            for (index, comname) in Comname.columnNames.enumerated() {
                FlowerArr.append(row[index] as! String)
            }
        }
    }
    
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
    
    @IBAction func OnAttClick(_ sender: Any) {
        var value = 0
        for i in 0...FlowerSighted.count {
            if (LocUpdate.text == FlowerSighted[i]) {
                value = i
                break
            }
        }
        N = SelectFlowers.text!
        L = Location[value]
        P = Person[value]
        Sight = Sightedon[value]
        
    }
    
    @IBAction func OnLocClick(_ sender: UIButton) {
        if (NewLoc.text!.contains("'")) {
            exit(X_OK)
        }
        let insert = try! db.run("UPDATE SIGHTINGS SET LOCATION = '" + NewLoc.text! + "'WHERE LOCATION = '" + L + "' AND PERSON = '" + P + "' AND NAME = '" + N + "';")
    }
    
    @IBAction func OnPerClick(_ sender: Any) {
        if (NewPerson.text!.contains("'")) {
            exit(X_OK)
        }
        let insert = try! db.run("UPDATE SIGHTINGS SET PERSON = '" + NewPerson.text! + "'WHERE LOCATION = '" + L + "' AND PERSON = '" + P + "' AND NAME = '" + N + "';")
    }
    
    @IBAction func OnDateClick(_ sender: Any) {
        if (NewDate.text!.contains("'")) {
            exit(X_OK)
        }
        let insert = try! db.run("UPDATE SIGHTINGS SET DATE = '" + NewDate.text! + "'WHERE LOCATION = '" + L + "' AND PERSON = '" + P + "' AND NAME = '" + N + "';")
    }
    @IBAction func OnGenClick(_ sender: UIButton) {
        if (NewGenus.text!.contains("\'")) {
            exit(X_OK)
        }
        let insert = try! db.run("UPDATE FLOWERS SET GENUS = '" + NewGenus.text! + "'WHERE COMNAME = '" + SelectFlowers.text! + "';")
    }
    @IBAction func OnSpeciesClick(_ sender: UIButton) {
        if (NewSpecies.text!.contains("\'")) {
            exit(X_OK)
        }
        let insert = try! db.run("UPDATE FLOWERS SET SPECIES = '" + NewSpecies.text! + "'WHERE COMNAME = '" + SelectFlowers.text! + "';")
    }
}

extension UpdateViewControl: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            self.SelectFlowers.reloadInputViews()
        case 1:
            if (FlowerSighted.isEmpty) {
                break
            }
            LocUpdate.text = FlowerSighted[row]
            self.LocUpdate.reloadInputViews()
        default:
            break
        }
    }
}
