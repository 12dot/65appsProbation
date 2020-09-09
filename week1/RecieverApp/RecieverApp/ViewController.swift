//
//  ViewController.swift
//  RecieverApp
//
//  Created by 12dot on 05.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideAllElements()
        
        
        //imageView.image = UIImage(named: "kit")
        
        /*
        let link = URL(string:"https://www.wikihow.com/Start-Learning-Computer-Programming")!
        let request = URLRequest(url: link)
        webView.load(request)
        */
    }
    
    
    func hideAllElements(){
        textLabel.isHidden = true
        webView.isHidden = true
        imageView.isHidden = true
    }
    

}

