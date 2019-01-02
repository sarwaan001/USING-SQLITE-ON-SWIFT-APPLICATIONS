//
//  ViewController.swift
//  Database
//
//  Created by Sarwaan Ansari on 12/11/18.
//  Copyright © 2018 Sarwaan Ansari. All rights reserved.
//

import UIKit
import SQLite

//INIT Database
var db = try! Connection("/Users/sarwaanansari/Documents/Xcode/COP3530/Projects/Database/Database/flowers.db")
var Comname = try! db.prepare("SELECT COMNAME FROM FLOWERS;")
var FlowerArr = [String]()
var FlowerSighted = [String]()
var Location = [String]()
var Person = [String]()
var Sightedon = [String]()


//Indexes
let indexsql1 = try! db.run("CREATE INDEX NAMEDEX ON SIGHTINGS (NAME);")
let indexsql2 = try! db.run("CREATE INDEX PERSONDEX ON SIGHTINGS (PERSON);")
let indexsql3 = try! db.run("CREATE INDEX LOCATIONDEX ON SIGHTINGS (LOCATION);")
let indexsql4 = try! db.run("CREATE INDEX SIGHTEDDEX ON SIGHTINGS (SIGHTED);")


//TRIGGER
let createdatatable = try! db.run("CREATE TABLE logdata(ACTIONS VARCHAR(255) NOT NULL, OLDNAME VARCHAR(255), NEWNAME VARCHAR(255));")
let createtrigger1 = try! db.run("CREATE TRIGGER AFTINSERT AFTER INSERT ON SIGHTINGS BEGIN INSERT INTO logdata VALUES ('INSERT', NULL, NEW.NAME); END;")
let createtrigger2 = try! db.run("CREATE TRIGGER AFTDELETE AFTER DELETE ON SIGHTINGS BEGIN INSERT INTO logdata VALUES ('DELETE', OLD.NAME, NULL); END;")
let createtrigger3 = try! db.run("CREATE TRIGGER AFTUPDATE AFTER UPDATE ON SIGHTINGS BEGIN INSERT INTO logdata VALUES ('INSERT', OLD.NAME, NEW.NAME); END;")

class ViewController: UIViewController {

    
    @IBOutlet weak var SelectFlowers: UITextField!
    @IBOutlet weak var FlowerTable: UITableView!
    
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
        thePicker.delegate = self
        thePicker.dataSource = self
        
        //let width = (view.frame.size.width-20)/3
        //let Layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //Layout.itemSize = CGSize(width:width, height:width)
        
        
    }
    
    func refreshonClick() {
        db = try! Connection("/Users/sarwaanansari/Documents/Xcode/COP3530/Projects/Database/Database/flowers.db")
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
    
    
    @IBAction func SelectOnClick(_ sender: UIButton) {
        refreshonClick()
        let sighted = try! db.prepare("SELECT COMNAME AS NAME, LOCATION, PERSON, SIGHTED FROM FLOWERS JOIN SIGHTINGS ON NAME = COMNAME WHERE NAME = '" + SelectFlowers.text! + "' ORDER BY SIGHTED DESC LIMIT 10;");
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
        for i in stride(from: 0, to: min(Person.count, Sightedon.count, Location.count), by: 1) {
            FlowerSighted.append(Location[i] + "-" + Person[i] + "-" + Sightedon[i])
        }
        
        self.FlowerTable.reloadData()
        
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FlowerArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return FlowerArr[row]
    }
    func pickerView(  _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SelectFlowers.text = FlowerArr[row]
        self.SelectFlowers.reloadInputViews()
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Location - Sighted - Date"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return FlowerSighted.count
        case 1:
            return FlowerSighted.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell "PlainCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        // Depending on the section, fill the textLabel with the relevant text
        switch indexPath.section {
        case 0:
            // Fruit Section
            cell.textLabel?.text = FlowerSighted[indexPath.row]
            break
        case 1:
            // Vegetable Section
            cell.textLabel?.text = FlowerSighted[indexPath.row]
            break
        default:
            break
        }
        
        // Return the configured cell
        return cell
        
    }
}

