//
//  TableViewController.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit


// MARK: - Delegate protocol for containe VC
protocol TableViewControllerDelegatePush {
    func pushAnswersData()
}

class TableViewController: UITableViewController {
    
    // MARK: - Declaration variables
    public var networkService = NetworkService()
    var delegateNew : TableViewControllerDelegatePush?

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    // MARK: - Configurations
    private func tableViewConfiguration(){
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Public methods
    public func getQuestionsData(activityIndicator: UIActivityIndicatorView){
        activityIndicator.startAnimating()
        networkService.getData(request: URLRequest(url: URL(string : "https://api.stackexchange.com/2.2/search/advanced?page=1&pagesize=50&order=desc&sort=creation&tagged=\(currentTag)&site=stackoverflow")!), completion: { result in
            
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self.navigationItem.title = "\(currentTag)"
                    self.networkService.parseQuestion(from: data, tableview: self.tableView)
                    activityIndicator.stopAnimating()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                activityIndicator.stopAnimating()
            }
        })
    }
    
 
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkService.questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.questionLabel.text = networkService.questions[indexPath.row].questionName
        cell.answerLabel.text = String(networkService.questions[indexPath.row].answersCount)
        cell.authorLabel.text = networkService.questions[indexPath.row].ownerName
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YY, h:mm:ss"
        let formattedDate = formatter.string(from: networkService.questions[indexPath.row].date as Date)
        cell.dateLabel.text = formattedDate
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentQuestion = indexPath.row
        delegateNew?.pushAnswersData()
    }

}
