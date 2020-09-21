//
//  AnswersViewController.swift
//  StackOverflow
//
//  Created by 12dot on 13.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit


class AnswersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    // MARK: - Variables
    public static let identifierFromContainer = "toAnswerVC"
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigurations()
        activityIndicatorConfiguation()
        
        getAnswers()
    }
    
    // MARK: - Configurations
    private func tableViewConfigurations(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func activityIndicatorConfiguation(){
        activityIndicator.hidesWhenStopped = true
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    // MARK: - Private methods
    private func getAnswers(){
        activityIndicator.startAnimating()
        NetworkService.getAnswersFromService(){
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkService.answers.count + 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.questionCellIdentifier, for: indexPath) as! QuestionTableViewCell
            cell.questionLabel.text = NetworkService.questions[NetworkService.currentQuestionId].questionName
            cell.authorLabel.text = NetworkService.questions[NetworkService.currentQuestionId].ownerName
            cell.questionLabel.font = UIFont.boldSystemFont(ofSize: 20)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.answerCellIdentifier, for: indexPath) as! AnswerTableViewCell
            cell.answerLabel.text = NetworkService.answers[indexPath.row-1].answerBody
            cell.authorLabel.text = NetworkService.answers[indexPath.row-1].ownerName
            return cell
        }
        
        
    }

}

extension AnswersViewController {
  enum Constants {
    static let answerCellIdentifier = "answerCell"
    static let questionCellIdentifier = "questionCell"
  }
}
