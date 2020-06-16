//
//  MainController.swift
//  memoryGameBar
//
//  Created by user166560 on 6/16/20.
//  Copyright © 2020 Gil Glick. All rights reserved.
//

import UIKit
import Foundation

class MainController: UIViewController {
    
    @IBOutlet weak var Main_BTN_highScroe: UIButton!
    @IBOutlet weak var Main_BTN_play: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
}
