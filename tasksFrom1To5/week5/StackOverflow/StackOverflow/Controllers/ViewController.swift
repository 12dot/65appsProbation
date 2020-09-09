//
//  ViewController.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CurtainViewControllerDelegate {
    
    var tableViewController =  TableViewController()
    var menuViewController = UIViewController()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewContentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var sideConstrait: NSLayoutConstraint!
    @IBAction func panDidAction(_ sender: UIPanGestureRecognizer) {

        if sender.state == .began  {
          
          let translation = sender.translation(in: self.view).x
          if translation > 0 {
              //right swipe
          } else if translation < 0{
              //left swipe
          }
                    
        } else if sender.state == .ended{
            if sideConstrait.constant < -100{
                sideConstrait.constant = -250
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            } else {
                sideConstrait.constant = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            
        } else {
            if sideConstrait.constant == -250{
                if sender.location(in: self.view).x > 30 {
                    return
                }
            }
            
            if sender.location(in: self.view).x <= 250 {
                sideConstrait.constant = -250 + sender.location(in: self.view).x
            }
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(menuView)
        activityIndicator.hidesWhenStopped = true
        
        
        tableViewController.getData(activityIndicator: activityIndicator)
    }
    
    func reloadData() {
        activityIndicator.startAnimating()
        tableViewController.getData(activityIndicator: activityIndicator)
        sideConstrait.constant = -250
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.destination is UINavigationController {
            let navigationVC = segue.destination as! UINavigationController
            tableViewController = navigationVC.viewControllers.first as! TableViewController
            //tableViewController = segue.destination as! TableViewController
        }
        if segue.destination is CurtainViewController {
            
            let menuViewControllerSeag = segue.destination as! CurtainViewController
            menuViewControllerSeag.delegate = self
            menuViewController = menuViewControllerSeag

        }
       
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if sideConstrait.constant == -250{
            sideConstrait.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else if sideConstrait.constant == 0 {
            sideConstrait.constant = -250
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
}

