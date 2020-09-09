//
//  ViewController.swift
//  second
//
//  Created by 12dot on 17.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

   
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelView: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Do any additional setup after loading the view.
        labelView.text = textView.text
    }
    
    func textViewDidChange(_ textView: UITextView) {
        labelView.text = textView.text
    }
    
    
    
    
}

