//
//  TableViewController.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController {
    
    
    var networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        
        //self.getData()
    }
    
    public func getData(activityIndicator: UIActivityIndicatorView){
        activityIndicator.startAnimating()
        networkService.getData(request: URLRequest(url: URL(string : "https://api.stackexchange.com/2.2/search/advanced?page=1&pagesize=50&order=desc&sort=creation&tagged=\(currentTag)&site=stackoverflow")!), completion: { result in
            
            switch result{
            case .success(let data):
                DispatchQueue.main.sync {
                    self.navigationItem.title = "\(currentTag)"
                    self.networkService.parseQuestion(from: data, tableview: self.tableView)
                    activityIndicator.stopAnimating()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }

    
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
