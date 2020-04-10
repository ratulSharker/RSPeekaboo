//
//  SecondViewController.swift
//  RSPeekaboo_Example
//
//  Created by Ratul Sharker on 7/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class SecondViewController : UIViewController {



    
    @IBAction func changeWindow(_ sender: Any) {
        if let secondTabbar = self.storyboard?.instantiateViewController(withIdentifier: "first_tabbar") {
            UIApplication.shared.keyWindow?.rootViewController = secondTabbar
        }
    }
}
