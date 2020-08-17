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
    
    let path = "receiverApp://"

    
    @IBAction func transferTextButton(_ sender: Any) {
        let buttonIdentifier = "1but"
        let searchQuerry = "Great! It is working".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = URL(string: path+buttonIdentifier+searchQuerry)
        openRecieverApp(url: url!)
        
    }
    
    @IBAction func transferURLButton(_ sender: Any) {
        let buttonIdentifier = "2but"
        let searchQuerry = "https://www.wikihow.com/Start-Learning-Computer-Programming"
        var component = URLComponents(string: searchQuerry)
        //component?.queryItems?.append
        let url = URL(string: path+buttonIdentifier+searchQuerry)
        openRecieverApp(url: url!)
        
        
    }
    
    @IBAction func transferImageButton(_ sender: Any) {
        let buttonIdentifier = "3but"
        let url = URL(string: path+buttonIdentifier)
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

