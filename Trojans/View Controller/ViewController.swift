//
//  ViewController.swift
//  Trojans
//
//  Created by Xcode User on 2019-11-19.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

     let getData = GetData()
     var num:Int?
    
    @IBAction func unwindToHomeVC(sender: UIStoryboardSegue)
    {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "table" {
            if let viewController = segue.destination as? TableViewController {
                if(num != nil){
                    viewController.tag = num
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

