//
//  LOGINViewController.swift
//  Database
//
//  Created by Sarwaan Ansari on 12/12/18.
//  Copyright © 2018 Sarwaan Ansari. All rights reserved.
//

import UIKit

class LOGINViewController: UIViewController {

    @IBOutlet weak var User: UITextField!
    @IBOutlet weak var Pass: UITextField!
    
    @IBOutlet weak var Loginbutton: UIButton!
    
    @IBAction func Login(_ sender: Any) {
        if (User.text == "admin" && Pass.text == "admin") {
            //performSegue(withIdentifier: "LoginId", sender: self)
        }
        else {
            exit(X_OK)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
