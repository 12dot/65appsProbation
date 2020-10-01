//
//  NetworkService.swift
//  StackOverflow
//
//  Created by 12dot on 01.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation
import UIKit

struct Question {
    let questionName : String
    let ownerName : String
    let date : NSDate
    let answersCount : Int
}



class NetworkService : NSObject, URLSessionDataDelegate {
    
    /*
    var tag : String
    var url: URL
    
    init(tag: String) {
        self.tag = tag
        self.url = URL(string: "https://api.stackexchange.com/2.2/search/advanced?page=1&pagesize=50&order=desc&sort=creation&tagged=\(tag)&site=stackoverflow")!
    }
    */
    
    public var questions = [Question]()
    
    public func getData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void){
        
        let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil{
                completion(.success(data))
            } else {
                print("Error getting data")
                completion(.failure(error!))
            
            }
        }
        dataTask.resume()
        
    }
    
    public func parseQuestion(from data : Data, tableview : UITableView){
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        //print(jsonObject)
        guard let json = jsonObject as? [String:Any] else {
            print("Invalid json")
            return
        }
        
        guard let jsonArray = json["items"] as? [[String:Any]] else {return print("JSON has no any items")}
        self.questions.removeAll()
        
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
        
        DispatchQueue.main.sync {
            tableview.reloadData()
        }
                
            } catch {
                print("error")
            }
        }
    
    
}
