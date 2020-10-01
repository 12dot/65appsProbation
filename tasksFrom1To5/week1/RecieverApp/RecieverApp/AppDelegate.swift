//
//  AppDelegate.swift
//  RecieverApp
//
//  Created by 12dot on 05.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        func getQueryStringParameter(url: String, param: String) -> String? {
          guard let url = URLComponents(string: url) else { return nil }
          return url.queryItems?.first(where: { $0.name == param })?.value
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = appDelegate.window!.rootViewController as! ViewController
        vc.hideAllElements()
        
        let identifier = getQueryStringParameter(url: "\(url)", param: "identifier")
    
        if identifier == "1"{
            
            let text = getQueryStringParameter(url: "\(url)", param: "text")
            vc.textLabel.isHidden = false
            vc.textLabel.text = text
            
        } else if identifier == "2"{
    
            vc.webView.isHidden = false
            let site = getQueryStringParameter(url: "\(url)", param: "site")
            let link = URL(string: site!)
            let request = URLRequest(url: link!)
            vc.webView.load(request)

        } else if identifier == "3" {
            
            vc.imageView.isHidden = false
            vc.imageView.image = UIImage(named: "kit")
            
        }
        return true
    }


}

