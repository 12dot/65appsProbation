//
//  ViewController.swift
//  StackOverflow
//
//  Created by 12dot on 31.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBAction func tagButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Tag", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            self.currentTag = self.tags[selectedRow]
            self.navigationItem.title = self.currentTag
            self.getData()
        
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var networkWorker = NetworkService()
    private lazy var tags = ["Swift" , "Objective-C" , "iOS" , "Xcode", "Cocoa-touch", "Iphone"]
    var currentTag = String()

    
    private struct Question {
        let questionName : String
        let ownerName : String
        let date : NSDate
        let answersCount : Int
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dataSourses and delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        
        activityIndicator.hidesWhenStopped = true
        
        currentTag = tags[0]
        
        self.navigationItem.title = currentTag
        
        self.getData()

        // Do any additional setup after loading the view.
    }
    
    
    private func getData(){
        networkWorker.getData(request: URLRequest(url: URL(string : "https://api.stackexchange.com/2.2/search/advanced?page=1&pagesize=50&order=desc&sort=creation&tagged=\(currentTag)&site=stackoverflow")!), completion: { result in
            
            switch result{
            case .success(let data):
                self.networkWorker.parseQuestion(from: data, tableview: self.tableView)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
    
    
    private func reloadAndDisplay() {
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
}



extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkWorker.questions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.questionLabel.text = networkWorker.questions[indexPath.row].questionName
        cell.answerLabel.text = String(networkWorker.questions[indexPath.row].answersCount)
        cell.authorLabel.text = networkWorker.questions[indexPath.row].ownerName
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YY, h:mm:ss"
        let formattedDate = formatter.string(from: networkWorker.questions[indexPath.row].date as Date)
        cell.dateLabel.text = formattedDate
        // Configure the cell...

        return cell
    }
    
    
    
}
