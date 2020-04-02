//
//  ViewController.swift
//  RSPeekaboo
//
//  Created by sharker.ratul.08@gmail.com on 04/02/2020.
//  Copyright (c) 2020 sharker.ratul.08@gmail.com. All rights reserved.
//

import UIKit
import RSPeekaboo

class ViewController: UIViewController {

    private var mLabel : UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.text = "😉 Peekaboo"
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 12.0)
        view.textColor = .white
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func peekabooPressed(_ sender: Any) {
        do {
            try RSPeekaboo.shared.peek(view: mLabel, height: CGFloat(50.0))
            
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                timer.invalidate()
                try? RSPeekaboo.shared.hide()
            }
        } catch {
            print(error)
        }
    }
}
