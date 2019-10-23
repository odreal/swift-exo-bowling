//
//  ViewController.swift
//  bowling
//
//  Created by Max on 17/10/2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func PlayButton(_ sender: Any) {
        print("clicked")
        if let next = self.storyboard?.instantiateViewController(withIdentifier: "GroundNormal") as? GroundNormalViewController {
            print("we have our playgroundNormal view controller! \(next)")
            NSLog("Macarena")
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
}

