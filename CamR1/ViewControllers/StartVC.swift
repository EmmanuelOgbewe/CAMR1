
//
//  StartVC.swift
//  CamR1
//
//  Created by Emmanuel  Ogbewe on 12/3/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.addTarget(self, action: #selector(StartVC.leaveView), for: .touchUpInside)
    }
    @objc
    func leaveView(){
        dismiss(animated: true, completion: nil)
    }
    
    
}
