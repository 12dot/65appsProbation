//
//  NetworkService.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation
import UIKit


let tags = ["Swift" , "Objective-C" , "iOS" , "Xcode", "Cocoa-touch", "Iphone"]
var currentTag = tags[0]
var currentQuestion : Int = 0


class NetworkService : NSObject, URLSessionDataDelegate {
    
    // MARK: - Properties
    public var questions = [Question]()
    public var answers = [Answer]()
    var dataSaver = DataSaver()
    
    // MARK: - Public methods
    public func getData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void){
        
        let dataFromFile = dataSaver.readDataFromFile(filename: currentTag)
        if dataFromFile != nil{
            completion(.success(dataFromFile!))
        } else {
            let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) in
                    
                if let data = data,
                    (response as? HTTPURLResponse)?.statusCode == 200,
                    error == nil{
                        self.dataSaver.createFileAndSave(filename: currentTag, data: data)
                        //self.dataSaver.createFile(filename: "\(request)", data: data)
                        completion(.success(data))
                    } else {
                        print("Error getting data")
                        completion(.failure(error!))
                    }
                }
            dataTask.resume()
        }
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
                    let ownerName = owner["display_name"] as? String,
                    let questionId = element["question_id"] as? Int
                    else {return print("JSON has no data")}
                
                let date = NSDate(timeIntervalSince1970: dateUNIX)
                questions.append(Question(questionName: title, ownerName: ownerName, date: date, answersCount: answers, questionId:  questionId))
            }
                tableview.reloadData()
        } catch {
            print("error")
        }
    }
    
    
    public func getAnswers(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
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
    
    public func parseAnswers(from data : Data, tableview : UITableView){
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            //print(jsonObject)
            guard let json = jsonObject as? [String:Any] else {
                print("Invalid json")
                return
            }
            
            guard let jsonArray = json["items"] as? [[String:Any]] else {return print("JSON has no any items")}
            self.answers.removeAll()
            
            for element in jsonArray.reversed(){
                guard
                    let owner = element["owner"] as? [String:Any],
                    let ownerName = owner["display_name"] as? String,
                    let answerBody = element["body"] as? String
                    else {return print("JSON has no data")}
    
                answers.append(Answer(ownerName: ownerName, answerBody: answerBody))
            }
            
                tableview.reloadData()
            
        } catch {
            print("error")
        }
    }
    
}

