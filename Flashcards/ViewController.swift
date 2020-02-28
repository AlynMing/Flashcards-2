//
//  ViewController.swift
//  Flashcards
//
//  Created by Sumi Kolli on 2/28/20.
//  Copyright © 2020 Sumi Kolli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        frontLabel.isHidden = true;
    }
    
    
}

