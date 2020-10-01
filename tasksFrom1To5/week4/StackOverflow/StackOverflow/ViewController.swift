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
            let selectedTag = self.tags[selectedRow]
            self.requestQuestion(for: selectedTag)
        
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    private lazy var questions = [Question]()
    private lazy var tags = ["Swift" , "Objective-C" , "iOS" , "Xcode", "Cocoa-touch", "Iphone"]
    
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
        //pickerView.delegate = self
        //pickerView.dataSource = self
        
        //pickerView.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        requestQuestion(for: tags[0])
        

        // Do any additional setup after loading the view.
    }
    
    
    private func requestQuestion(for tag : String){
        activityIndicator.startAnimating()
        guard let url = URL(string: "https://api.stackexchange.com/2.2/search/advanced?page=1&pagesize=50&order=desc&sort=creation&tagged=\(tag)&site=stackoverflow") else {return}
        let dataTask = URLSession.shared.dataTask(with: url){ (data, response, error) in
            
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil{
                self.parseQuestion(from: data)
                DispatchQueue.main.sync {
                    self.navigationItem.title = "\(tag)"
                }
            } else {
                    print("Error getting data")
            
            }
        }
        dataTask.resume()
    }
    
    
    private func parseQuestion(from data : Data){
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            //print(jsonObject)
            guard let json = jsonObject as? [String:Any] else {
                print("Invalid json")
                return
            }
            
            guard let jsonArray = json["items"] as? [[String:Any]] else {return print("JSON has no any items")}
            questions.removeAll()
            
            for element in jsonArray.reversed(){
                guard
                    let dateUNIX = element["last_activity_date"] as? Double,
                    let title = element["title"] as? String,
                    let answers = element["answer_count"] as? Int,
                    let owner = element["owner"] as? [String:Any],
                    let ownerName = owner["display_name"] as? String else {return print("JSON has no data")}
                
                let date = NSDate(timeIntervalSince1970: dateUNIX)
                questions.append(Question(questionName: title, ownerName: ownerName, date: date, answersCount: answers))
                
            }
            
            DispatchQueue.main.sync { [weak self] in
                self?.reloadAndDisplay()
            }
            
        } catch {
            print("error")
        }
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
        return questions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.questionLabel.text = questions[indexPath.row].questionName
        cell.answerLabel.text = String(questions[indexPath.row].answersCount)
        cell.authorLabel.text = questions[indexPath.row].ownerName
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YY, h:mm:ss"
        let formattedDate = formatter.string(from: questions[indexPath.row].date as Date)
        cell.dateLabel.text = formattedDate
        // Configure the cell...

        return cell
    }
    
    
    
}
