//
//  ViewController.swift
//  secondApp
//
//  Created by 12dot on 05.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    let sheme = "receiverApp://"

    
    @IBAction func transferTextButton(_ sender: Any) {
        
        
        let queryItems = [URLQueryItem(name: "identifier", value: "1"), URLQueryItem(name: "text", value: "Great!. It's working")]
        var urlComps = URLComponents(string: sheme)
        urlComps?.queryItems = queryItems
        let url = urlComps?.url
        openRecieverApp(url: url!)
        
        
        
        
    }
    
    @IBAction func transferURLButton(_ sender: Any) {
        
        
        let queryItems = [URLQueryItem(name: "identifier", value: "2"), URLQueryItem(name: "site", value: "https://www.wikihow.com/Start-Learning-Computer-Programming")]
        var urlComps = URLComponents(string: sheme)
        urlComps?.queryItems = queryItems
        let url = urlComps?.url
        openRecieverApp(url: url!)
        
        
        
    }
    
    @IBAction func transferImageButton(_ sender: Any) {
        let queryItems = [URLQueryItem(name: "identifier", value: "3")]
        var urlComps = URLComponents(string: sheme)
        urlComps?.queryItems = queryItems
        let url = urlComps?.url
        openRecieverApp(url: url!)
               
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton(button: textButton)
        styleButton(button: imageButton)
        styleButton(button: urlButton)
        // Do any additional setup after loading the view.
    }

    
    func openRecieverApp(url : URL){
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
           let alert = UIAlertController(title: "Receiver not found", message: "ReceiverApp is not installed on this device", preferredStyle: .alert)
           let ok = UIAlertAction(title: "Ok", style: .default, handler: {
               _ in
               self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func styleButton(button : UIButton){
        
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.backgroundColor = .darkGray
        
    }
    
    

}

