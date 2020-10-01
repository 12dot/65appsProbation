//
//  NetworkService.swift
//  StackOverflow
//
//  Created by 12dot on 04.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation
import UIKit



class NetworkService : NSObject, URLSessionDataDelegate {
    
    public static var tagIndex : Int = 0
    public static var currentQuestionId : Int = Int()
    
    public static var questions : [Question] = []
    public static var answers : [Answer] = []
    
    public static let tags = ["Swift" , "Objective-C" , "iOS" , "Xcode", "Cocoa-touch", "Iphone"]
        
    private enum NetworkErrors: Error {
        case invalidURL
        case invalidJSON
        case invalidResponse
        case unknownError
    }
    
    private class func getQuestionsData(completion: @escaping (Result<Data, Error>) -> Void) {
        
        let currentTag  = NetworkService.tags[tagIndex]

    
        let dataFromFile = DataSaver.readDataFromFile(filename: currentTag)
        if dataFromFile != nil {
            completion(.success(dataFromFile!))
        } else {
            let currentTag  = NetworkService.tags[tagIndex]
            guard let url = URL(string: "https://api.stackexchange.com/2.2/search/advanced?page=1&pagesize=50&order=desc&sort=creation&tagged=\(currentTag)&site=stackoverflow") else {
                //throw NetworkErrors.invalidURL
                return print("Wrong URL")}
            let dataTask = URLSession.shared.dataTask(with: url){(data, response, error) in
                if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil{
                    DataSaver.createFileAndSave(filename: currentTag, data: data)
                    completion(.success(data))
                } else {
                    guard let error = error else {
                        return print("Unknown error")
                    }
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
    }
    
    private class func parseQuestionsData(from data : Data) throws {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard let json = jsonObject as? [String:Any] else {
                throw NetworkErrors.invalidJSON
            }
            guard let jsonArray = json["items"] as? [[String:Any]] else {throw NetworkErrors.invalidJSON}
            NetworkService.questions.removeAll()
            
            for element in jsonArray.reversed(){
                guard
                    let dateUNIX = element["last_activity_date"] as? Double,
                    let title = element["title"] as? String,
                    let answers = element["answer_count"] as? Int,
                    let owner = element["owner"] as? [String:Any],
                    let ownerName = owner["display_name"] as? String,
                    let questionId = element["question_id"] as? Int
                else {throw NetworkErrors.invalidJSON}
                
                let date = NSDate(timeIntervalSince1970: dateUNIX)
                NetworkService.questions.append(Question(questionName: title, ownerName: ownerName, date: date, answersCount: answers, questionId:  questionId))
            }
        } catch let error {
                throw error
        }
    }
    
    private class func getAnswersData(completion: @escaping (Result<Data, Error>) -> Void){
        let currentQuestionIdentifier = questions[currentQuestionId].questionId
        guard let url = URL(string: "https://api.stackexchange.com/questions/\(currentQuestionIdentifier)/answers?order=desc&sort=activity&site=stackoverflow&filter=withbody") else { return print("Wrong URL") }
        let dataTask = URLSession.shared.dataTask(with: url){(data, response, error) in
            
            if let data = data,
            (response as? HTTPURLResponse)?.statusCode == 200,
            error == nil{
                completion(.success(data))
            } else {
                guard let error = error else {
                    return print("Unknown error")
                }
                print("Error getting data")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    private class func parseAnswersData(from data : Data) throws{
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let json = jsonObject as? [String:Any] else {
                throw NetworkErrors.invalidJSON
            }
            
            guard let jsonArray = json["items"] as? [[String:Any]] else {
                throw NetworkErrors.invalidJSON
            }
            answers.removeAll()
            
            for element in jsonArray.reversed(){
                guard
                    let owner = element["owner"] as? [String:Any],
                    let ownerName = owner["display_name"] as? String,
                    let answerBody = element["body"] as? String
                else {throw NetworkErrors.invalidJSON}
    
                answers.append(Answer(ownerName: ownerName, answerBody: answerBody))
            }
        } catch let error {
            throw error
        }
    }
    
    public static func getQuestionsFromService(completition: @escaping (Error?) -> Void){
        var errorRecieved : Error? = nil
        getQuestionsData(completion: { result in
            switch result{
            case .success(let data):
                do{
                    try parseQuestionsData(from: data)
                } catch {
                    errorRecieved = error
                }
            case .failure(let error):
                errorRecieved = error
            }
            if errorRecieved == nil{
                completition(nil)
            } else {
                completition(errorRecieved)
            }
        })
    }
    
    public static func getAnswersFromService(completition: @escaping (Error?) -> Void){
        var errorRecieved : Error? = nil
        getAnswersData(completion: { result in
            switch result{
            case .success(let data):
                do{
                    try parseAnswersData(from: data)
                } catch {
                    errorRecieved = error
                }
            case .failure(let error):
                errorRecieved = error
            }
            if errorRecieved == nil{
                completition(nil)
            } else {
                completition(errorRecieved)
            }
        })
    }
}
