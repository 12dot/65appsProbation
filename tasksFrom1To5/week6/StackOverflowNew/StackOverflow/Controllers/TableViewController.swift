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
    
    // MARK: - Variables
    public static let identifierFromContainer = "toTableVC"
    private static let cellIdentifier = "cell"
    
    // MARK: - Declaration variables
    var delegateNew : TableViewControllerDelegatePush?
    
    // MARK: - Configurations
    private func tableViewConfiguration(){
        self.tableView.rowHeight = UITableView.automaticDimension
    }
 
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkService.questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewController.cellIdentifier, for: indexPath) as! TableViewCell
        
        cell.questionLabel.text = NetworkService.questions[indexPath.row].questionName
        cell.answerLabel.text = String(NetworkService.questions[indexPath.row].answersCount)
        cell.authorLabel.text = NetworkService.questions[indexPath.row].ownerName
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YY, h:mm:ss"
        let formattedDate = formatter.string(from: NetworkService.questions[indexPath.row].date as Date)
        cell.dateLabel.text = formattedDate
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkService.currentQuestionId = indexPath.row
        delegateNew?.pushAnswersData()
    }

}
