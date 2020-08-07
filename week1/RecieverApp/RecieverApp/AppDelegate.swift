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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = appDelegate.window!.rootViewController as! ViewController
        vc.hideAllElements()
        let text = url.host
        
        if text?.prefix(4) == "1but"{
            
            var text = url.host?.removingPercentEncoding
            text?.removeFirst(4)
            vc.textLabel.isHidden = false
            vc.textLabel.text = text
            
        } else if text?.prefix(4) == "2but" {
    
            vc.webView.isHidden = false
            var linkURL = url.host!+":"+url.path
            linkURL.removeFirst(4)
            let link = URL(string: linkURL)
            let request = URLRequest(url: link!)
            vc.webView.load(request)

        } else if text?.prefix(4) == "3but" {
            
            vc.imageView.isHidden = false
            vc.imageView.image = UIImage(named: "kit")
            
        }
        return true
    }


}

