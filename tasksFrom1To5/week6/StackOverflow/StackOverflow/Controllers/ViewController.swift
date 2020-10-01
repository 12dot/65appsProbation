//
//  ViewController.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CurtainViewControllerDelegate, TableViewControllerDelegatePush {
    
    // MARK: - VCs to get them from class
    var tableViewController =  TableViewController()
    var menuViewController = UIViewController()
    var answerTableVC = AnswersViewController()
    
    // MARK: - Variables
    private let animationDuration = 0.3

    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewContentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var sideConstrait: NSLayoutConstraint!
    
    // MARK: - Curtain moving
    @IBAction func panDidAction(_ sender: UIPanGestureRecognizer) {

        // MARK: - Variables
        let middlePostion : CGFloat = -100
        let leftPosition : CGFloat = -250
        let rightPosition: CGFloat = 0
        let fingerRightPostion : CGFloat = 250
        let fingerOutOfRange : CGFloat = 30
        
         if sender.state == .ended{
            if sideConstrait.constant < middlePostion{
                sideConstrait.constant = leftPosition
                UIView.animate(withDuration: animationDuration) {
                    self.view.layoutIfNeeded()
                }
            } else {
                sideConstrait.constant = rightPosition
                UIView.animate(withDuration: animationDuration) {
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            if sideConstrait.constant == leftPosition{
                if sender.location(in: self.view).x > fingerOutOfRange {
                    return
                }
            }
            
            if sender.location(in: self.view).x <= fingerRightPostion {
                sideConstrait.constant = leftPosition + sender.location(in: self.view).x
            }
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curtainConfigutaion()
        activityIndicatorConfiguration()
        tableViewController.getQuestionsData(activityIndicator: activityIndicator)
    }
    
    // MARK: - Configurations
    private func curtainConfigutaion (){
        view.bringSubviewToFront(menuView)
    }
    private func activityIndicatorConfiguration(){
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Delegates methods from VCs
    func reloadData() {
        activityIndicator.startAnimating()
        tableViewController.getQuestionsData(activityIndicator: activityIndicator)
        sideConstrait.constant = -250
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func pushAnswersData() {
        performSegue(withIdentifier: "toAnswerVC", sender: self)
    }
    
    // MARK: - get access to VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toAnswerVC"{
            let navigationVC = segue.destination as! UINavigationController
            answerTableVC = navigationVC.viewControllers.first as! AnswersViewController
            answerTableVC.networkService = tableViewController.networkService
        }
        if segue.identifier == "toTableVC" {
            let navigationVC = segue.destination as! UINavigationController
            tableViewController = navigationVC.viewControllers.first as! TableViewController
            tableViewController.delegateNew = self
        }
        if segue.destination is CurtainViewController {
            let menuViewControllerSeag = segue.destination as! CurtainViewController
            menuViewControllerSeag.delegate = self
            menuViewController = menuViewControllerSeag
        }
       
    }
    
    // MARK: - Shaking effect
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if sideConstrait.constant == -250{
            sideConstrait.constant = 0
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        } else if sideConstrait.constant == 0 {
            sideConstrait.constant = -250
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

