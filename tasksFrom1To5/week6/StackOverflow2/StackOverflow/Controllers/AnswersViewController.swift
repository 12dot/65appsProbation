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
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    var networkService : NetworkService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 1.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        getAnswersData()
    }
    
    // MARK: - Private methods
    private func getAnswersData() {
        guard let questionId = networkService?.questions[currentQuestion].questionId else {
            return print("no value")
        }
        networkService?.getAnswers(request: URLRequest(url: URL(string: "https://api.stackexchange.com/questions/\(questionId)/answers?order=desc&sort=activity&site=stackoverflow&filter=withbody")!), completion: {result in
                     
                     switch result{
                         
                     case .success(let data):
                        DispatchQueue.main.sync {
                            self.networkService?.parseAnswers(from: data, tableview: self.tableView)
                        }
                     case .failure(let error):
                           print(error.localizedDescription)
                   }
               })
       }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (networkService?.answers.count)! + 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerTableViewCell
        
        if indexPath.row == 0 {
            cell.answerLabel.text = networkService?.questions[currentQuestion].questionName
            cell.authorLabel.text = networkService?.questions[currentQuestion].ownerName
            cell.answerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            cell.answerLabel.text = networkService?.answers[indexPath.row-1].answerBody
            cell.authorLabel.text = networkService?.answers[indexPath.row-1].ownerName
        }
        
 
        return cell
        
    }

}
