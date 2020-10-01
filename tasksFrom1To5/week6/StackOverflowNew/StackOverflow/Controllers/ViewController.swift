//
//  ViewController.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CurtainViewControllerDelegate, TableViewControllerDelegatePush, ErrorPresentable{
    
    // MARK: - VCs to get them from class
    var tableViewController =  TableViewController()
    var menuViewController = CurtainViewController()
    var answerTableVC = AnswersViewController()
    
    // MARK: - Consts fot curtain
    private let animationDuration = 0.3
    let middlePostion : CGFloat = -100
    let leftPosition : CGFloat = -250
    let rightPosition: CGFloat = 0
    let fingerRightPostion : CGFloat = 250
    let fingerOutOfRange : CGFloat = 30
    
    
    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewContentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var sideConstrait: NSLayoutConstraint!
    
    // MARK: - Curtain moving
    @IBAction func panDidAction(_ sender: UIPanGestureRecognizer) {
        
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        curtainConfigutaion()
        activityIndicatorConfiguration()
        
        reloadQuestionsData()
    }
    
    // MARK: - Configurations
    private func curtainConfigutaion (){
        view.bringSubviewToFront(menuView)
    }
    private func activityIndicatorConfiguration(){
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Delegates methods from VCs
    func reloadQuestionsData() {
        activityIndicator.startAnimating()
        NetworkService.getQuestionsFromService(){ result in
            switch result{
            case .none:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableViewController.tableView.reloadData()
                }
            case .some(let error):
                DispatchQueue.main.sync {
                    self.activityIndicator.stopAnimating()
                    self.showError(error: error)
                }
            }
        }
        if sideConstrait.constant != leftPosition{
            sideConstrait.constant = leftPosition
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func pushAnswersData() {
        performSegue(withIdentifier: "toAnswerVC", sender: self)
    }
    
    // MARK: - Access to VCs by segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        switch segue.identifier {
        case TableViewController.identifierFromContainer:
            let navigationVC = segue.destination as! UINavigationController
            tableViewController = navigationVC.viewControllers.first as! TableViewController
            tableViewController.delegateNew = self
        case AnswersViewController.identifierFromContainer:
            let navigationVC = segue.destination as! UINavigationController
            answerTableVC = navigationVC.viewControllers.first as! AnswersViewController
        case CurtainViewController.identifierFromContainer:
            let menuViewControllerSeag = segue.destination as! CurtainViewController
            menuViewControllerSeag.delegate = self
            menuViewController = menuViewControllerSeag
        default:
            print("Error")
        }
    }
    
    // MARK: - Shaking effect
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if sideConstrait.constant == leftPosition{
            sideConstrait.constant = rightPosition
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        } else if sideConstrait.constant == rightPosition {
            sideConstrait.constant = leftPosition
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

